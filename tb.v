`timescale 1ns / 1ps

module tb_dct_controller_fsm;

    reg clk, rst;
    reg data_in_valid;
    reg data_out_ready;
    reg signed [8:0] x0, x1, x2, x3, x4, x5, x6, x7;
    wire data_in_ready;
    wire data_out_valid;
    wire signed [10:0] y0, y1;
    wire signed [25:0] y2, y3;
    wire signed [26:0] y4, y5, y6, y7;

    // Instantiate the DUT
    controller uut (
        .clk(clk),
        .rst(rst),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_out_ready(data_out_ready),
        .data_out_valid(data_out_valid),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3),
        .y4(y4), .y5(y5), .y6(y6), .y7(y7)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100 MHz clock

    // Stimulus
    initial begin
        rst = 1;
        data_in_valid = 0;
        data_out_ready = 1;
        x0 =0 ; x1 = 0; x2 = 0; x3 = 0;
        x4 = 0; x5 = 0; x6 = 0; x7 = 0;

        #20 rst = 0;
        @(posedge clk);

        // Apply one set of input data
        data_in_valid = 1;
        x0 = 10; x1 = 20; x2 = 30; x3 = 40;
        x4 = 50; x5 = 60; x6 = 70; x7 = 80;

        @(posedge clk);
        data_in_valid = 0;  // One-cycle input valid

        // Wait for processing and observe output
        wait (data_out_valid);
        $display("Output valid at time %t", $time);
        $display("Y0=%d, Y1=%d, Y2=%d, Y3=%d, Y4=%d, Y5=%d, Y6=%d, Y7=%d",
                 y0, y1, y2, y3, y4, y5, y6, y7);

        // Hold ready high for a few cycles
        repeat(5) @(posedge clk);

        // Now simulate backpressure (stall)
        data_out_ready = 0;
        repeat(5) @(posedge clk);
        data_out_ready = 1;

        repeat(5) @(posedge clk);
        $finish;
    end

endmodule
