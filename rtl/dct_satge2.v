`timescale 1ns / 1ps

module dct_stage2(
    input reset,
    input clk,
    input  wire signed [8:0] r0, r1, r2, r3, r4, r5, r6, r7, // Q10.8 inputs
    output reg signed [24:0] y4, y5, y6, y7, // Q10.15                 
    output reg signed [9:0] y0, y1, y2, y3
    );
    wire signed [24:0] t0, t1, t2, t3;
    wire signed [24:0] k0, k1, k2, k3;
    wire signed [24:0] r4_q = r4 <<< 15;
    wire signed [24:0] r5_q = r5 <<< 15;
    wire signed [24:0] r6_q = r6 <<< 15;
    wire signed [24:0] r7_q = r7 <<< 15;


     // K1=((1*cos(pi/16))*2^15)->csd(32138)=x + (x >> 12) + (x >> 14) - (x >> 6) - (x >> 8)

    //K2=((1*sin(pi/16))*2^15)->csd(6393)=(x>>2)+ (x >> 7) - (x >> 4) - (x >> 12) +(x >> 15)
    
    //K3=((1*cos(3pi/16))*2^15->csd(27245)=(x>>15)-(x >>13) - (x >> 11) + (x >> 8) +(x >> 6)+(x >> 4)-(x >> 2)+x
    //K4=((1*cos(5pi/16))*2^15->csd(18205)=(x>>15)-(x >>13) + (x >> 10) - (x >> 7) +(x >> 6)+(x >> 4)-(x >> 1)
    
    // Internal registers to hold intermediate products

    assign t0=r5_q + (r5_q >>> 12) + (r5_q >>> 14) - (r5_q >>> 6) - (r5_q >>> 8);
    assign t1=(r6_q>>>2)+ (r6_q >>> 7) - (r6_q >>> 4) - (r6_q >>> 12) +(r6_q >>> 15);
    assign t2=r6_q + (r6_q >>> 12) + (r6_q >>> 14) - (r6_q >>> 6) - (r6_q >>> 8);
    assign t3=(r5_q>>>2)+ (r5_q >>> 7) - (r5_q >>> 4) - (r5_q >>> 12) +(r5_q >>> 15);
    
    assign k0=(r4_q>>>15)-(r4_q>>>13) - (r4_q>>> 11) + (r4_q>>> 8) +(r4_q>>> 6)+(r4_q>>> 4)-(r4_q>>> 2)+r4_q;
    assign k1=(r7_q>>>15)-(r7_q >>>13) + (r7_q >>> 10) - (r7_q >>> 7) +(r7_q >>> 4)+(r7_q >>> 1);
    assign k2=(r7_q>>>15)-(r7_q>>>13) - (r7_q>>> 11) + (r7_q>>> 8) +(r7_q>>> 6)+(r7_q>>> 4)-(r7_q>>> 2)+r7_q;
    assign k3=(r4_q>>>15)-(r4_q >>>13) + (r4_q >>> 10) - (r4_q >>> 7) +(r4_q >>> 4)+(r4_q >>> 1);
    always @(posedge clk) begin
        if(reset)begin
        y5 <= 0;
        y6 <= 0;
        y4 <= 0;
        y7 <= 0;
        y0 <= 0;
        y1 <= 0;
        y2 <= 0;
        y3 <= 0;
        end
        else begin
        y5 <= t0 + t1;
        y6 <= t2 - t3;
        y4 <= k0 + k1;
        y7 <= k2 - k3;
        y0 <= r0 + r3;
        y1 <= r1 + r2;
        y2 <= r1 - r2;
        y3 <= r0 - r3;
        end
        $display("\n--- DCT input Stage 2 ---");
        $display("r0=%d", r0);
        $display("r1=%d", r1);
        $display("r2=%d", r2);
        $display("r3=%d", r3);
        $display("r4=%d", r4);
        $display("r5=%d", r5);
        $display("r6=%d", r6);
        $display("r7=%d", r7);
        $display("------------------\n");
        $display("\n--- DCT Output Stage 2 ---");
        $display("y0=%d", y0);
        $display("y1=%d", y1);
        $display("y2=%d", y2);
        $display("y3=%d", y3);
        $display("y4=%d", y4);
        $display("y5=%d", y5);
        $display("y6=%d", y6);
        $display("y7=%d", y7);
        $display("------------------\n");
    end
    
endmodule

