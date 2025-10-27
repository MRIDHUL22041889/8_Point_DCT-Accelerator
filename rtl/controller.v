`timescale 1ns / 1ps

module controller (
    input  wire clk,
    input  wire rst,

    // Input handshake
    input  wire data_in_valid,
    output wire data_in_ready, // Output is now combinational

    // Output handshake
    input  wire data_out_ready,
    output wire  data_out_valid,

    // DCT data ports
    input  wire signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    output reg  signed [10:0] y0, y1,
    output reg  signed [25:0] y2, y3,
    output reg  signed [26:0] y4, y5, y6, y7
);

    //-----------------------------------------
    // DCT instantiation (No changes)
    //-----------------------------------------
    wire signed [10:0] dct_y0, dct_y1;
    wire signed [25:0] dct_y2, dct_y3;
    wire signed [26:0] dct_y4, dct_y5, dct_y6, dct_y7;

    dct u_dct (
        .clk(clk),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .y0(dct_y0), .y1(dct_y1),
        .y2(dct_y2), .y3(dct_y3),
        .y4(dct_y4), .y5(dct_y5),
        .y6(dct_y6), .y7(dct_y7)
    );

    //-----------------------------------------
    // Direct Pipeline Control (No FSM)
    //-----------------------------------------

    // A stall occurs if the output is valid but not ready to be accepted.
    // This is the single signal that will control the entire pipeline flow.
    wire is_stalled = data_out_valid && !data_out_ready;

    // We are ready to accept new input ONLY if the pipeline is not stalled.
    assign data_in_ready = !is_stalled;

    // This signal represents a valid transaction being accepted into the pipeline.
    wire new_data_accepted = data_in_valid && data_in_ready;
    
    // The output is valid if the pipeline tracker's last stage bit is high.
    reg [6:0] pipeline_tracker;
    assign data_out_valid = pipeline_tracker[6];

    // Sequential logic for the pipeline tracker
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_tracker <= 7'b0000000;
        end else begin
            // The pipeline tracker ONLY advances if the system is not stalled.
            if (!is_stalled) begin
                pipeline_tracker <= {pipeline_tracker[5:0], new_data_accepted};
            end
        end
    end

    //-----------------------------------------
    // Output Registration
    //-----------------------------------------
    // The output data registers also ONLY update when the system is not stalled.
    // This holds the output data constant during a stall, as required.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y0 <= 0; y1 <= 0; y2 <= 0; y3 <= 0;
            y4 <= 0; y5 <= 0; y6 <= 0; y7 <= 0;
        end else begin
            if (!is_stalled) begin
                y0 <= dct_y0; y1 <= dct_y1;
                y2 <= dct_y2; y3 <= dct_y3;
                y4 <= dct_y4; y5 <= dct_y5;
                y6 <= dct_y6; y7 <= dct_y7;
            end
        end
    end

endmodule