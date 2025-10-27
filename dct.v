`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Top-level 1D DCT (8-point) - WITH CORRECTED FSM
// Integrates stage1 → stage4
//////////////////////////////////////////////////////////////////////////////////
module dct (
    input  wire clk,
    input  wire signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    output reg signed [10:0] y0, y1,
    output reg signed [25:0] y2, y3,
    output reg signed [26:0] y4, y5, y6, y7
);

   

    // ---------------- Stage 1 ----------------
    wire signed [8:0] s1_r0, s1_r1, s1_r2, s1_r3, s1_r4, s1_r5, s1_r6, s1_r7;
    dct_stage1 u_stage1 (
        .clk(clk), // Pass clock if needed, even if stage is registered
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .r0(s1_r0), .r1(s1_r1), .r2(s1_r2), .r3(s1_r3),
        .r4(s1_r4), .r5(s1_r5), .r6(s1_r6), .r7(s1_r7)
    );

    // ---------------- Pipeline Register 1 ----------------
    reg signed [8:0] p1_r0, p1_r1, p1_r2, p1_r3, p1_r4, p1_r5, p1_r6, p1_r7;
    always @(posedge clk) begin
            p1_r0 <= s1_r0; p1_r1 <= s1_r1; p1_r2 <= s1_r2; p1_r3 <= s1_r3;
            p1_r4 <= s1_r4; p1_r5 <= s1_r5; p1_r6 <= s1_r6; p1_r7 <= s1_r7;
    end

    // ---------------- Stage 2 ----------------
    wire signed [9:0]  s2_y0, s2_y1, s2_y2, s2_y3;
    wire signed [25:0] s2_y4, s2_y5, s2_y6, s2_y7;
    dct_stage2 u_stage2 (
        .clk(clk),
        .r0(p1_r0), .r1(p1_r1), .r2(p1_r2), .r3(p1_r3),
        .r4(p1_r4), .r5(p1_r5), .r6(p1_r6), .r7(p1_r7),
        .y0(s2_y0), .y1(s2_y1), .y2(s2_y2), .y3(s2_y3),
        .y4(s2_y4), .y5(s2_y5), .y6(s2_y6), .y7(s2_y7)
    );

    // ---------------- Pipeline Register 2 ----------------
    reg signed [9:0]  p2_y0, p2_y1;
    reg signed [25:0] p2_y2, p2_y3, p2_y4, p2_y5, p2_y6, p2_y7;
    always @(posedge clk) begin
            p2_y0 <= s2_y0; p2_y1 <= s2_y1;
            p2_y2 <= s2_y2; p2_y3 <= s2_y3;
            p2_y4 <= s2_y4; p2_y5 <= s2_y5;
            p2_y6 <= s2_y6; p2_y7 <= s2_y7;
    end

    // ---------------- Stage 3 ----------------
    wire signed [10:0] s3_y0, s3_y1;
    wire signed [25:0] s3_y2, s3_y3;
    wire signed [26:0] s3_y4, s3_y5, s3_y6, s3_y7;
    dct_stage3 u_stage3 (
        .clk(clk),
        .r0(p2_y0), .r1(p2_y1), .r2(p2_y2), .r3(p2_y3),
        .r4(p2_y4), .r5(p2_y5), .r6(p2_y6), .r7(p2_y7),
        .y0(s3_y0), .y1(s3_y1), .y2(s3_y2), .y3(s3_y3),
        .y4(s3_y4), .y5(s3_y5), .y6(s3_y6), .y7(s3_y7)
    );

    // ---------------- Pipeline Register 3 ----------------
    reg signed [10:0] p3_y0, p3_y1;
    reg signed [25:0] p3_y2, p3_y3;
    reg signed [26:0] p3_y4, p3_y5, p3_y6, p3_y7;
    always @(posedge clk) begin
            p3_y0 <= s3_y0; p3_y1 <= s3_y1;
            p3_y2 <= s3_y2; p3_y3 <= s3_y3;
            p3_y4 <= s3_y4; p3_y5 <= s3_y5;
            p3_y6 <= s3_y6; p3_y7 <= s3_y7;
    end

    // ---------------- Stage 4 ----------------
    wire signed [10:0] s4_y0, s4_y1;
    wire signed [25:0] s4_y2, s4_y3;
    wire signed [26:0] s4_y4, s4_y5, s4_y6, s4_y7;
    dct_stage4 u_stage4 (
        .clk(clk),
        .r0(p3_y0), .r1(p3_y1),
        .r2(p3_y2), .r3(p3_y3),
        .r4(p3_y4), .r5(p3_y5), .r6(p3_y6), .r7(p3_y7),
        .y0(s4_y0), .y1(s4_y1),
        .y2(s4_y2), .y3(s4_y3),
        .y4(s4_y4), .y5(s4_y5), .y6(s4_y6), .y7(s4_y7)
    );


    always @(posedge clk) begin
             y0 <= s4_y0; y1 <= s4_y1;
             y2 <= s4_y2; y3 <= s4_y3;
             y4 <= s4_y4; y5 <= s4_y5;
             y6 <= s4_y6; y7 <= s4_y7;

    end

endmodule