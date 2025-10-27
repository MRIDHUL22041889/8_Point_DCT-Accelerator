`timescale 1ns / 1ps



module dct_stage3(
    input reset,
    input clk,
    input  wire signed [9:0]  r0, r1, r2, r3,
    input  wire signed [24:0] r4, r5, r6, r7, // Q10.15 inputs
    output reg signed [25:0] y4, y5, y6, y7, // widened to Q11.15
    output reg signed [25:0] y2, y3,         // stays Q10.15
    output reg signed [10:0] y0, y1          // widened for r0+r1
);

   //k0=(x >> 1) + (x >> 5) + (x >> 7) + (x >> 9)+ (x >> 12)-(x >> 14)
   //k1=(x) + (x >> 2) + (x >> 4) - (x >> 7)+ (x >> 9)-(x >> 13)+(x>>15)
     wire signed [24:0] r2_q = r2 <<< 15;
     wire signed [24:0] r3_q = r3 <<< 15;
     assign t0=(r2 >>> 1) + (r2 >>> 5) + (r2 >>> 7) + (r2 >>> 9)+ (r2 >>> 12)-(r2 >>> 14);
     assign t1=(r3) + (r3 >>> 2) + (r3 >>> 4) - (r3 >>> 7)+ (r3 >>> 9)-(r3 >>> 13)+(r3>>>15);
     assign t2=(r3 >>> 1) + (r3 >>> 5) + (r3 >>> 7) + (r3 >>> 9)+ (r3 >>> 12)-(r3 >>> 14);
     assign t3=(r2) + (r2 >>> 2) + (r2 >>> 4) - (r2 >>> 7)+ (r2 >>> 9)-(r2 >>> 13)+(r2>>>15);
    always @(posedge clk) begin
        if(reset)begin
        y2 <= 0;
        y3 <= 0;
        y4 <= 0;
        y6 <= 0;
        y5 <= 0;
        y7 <= 0;
        y0 <= 0;
        y1 <= 0;
        end
        else begin
        y2 <= t0 + t1;
        y3 <= t2 - t3;
        y4 <= r4 + r6;
        y6 <= r4 - r6;
        y5 <= r7 - r5;
        y7 <= r5 + r7;
        y0 <= r0 + r1;
        y1 <= r0 - r1;
        end
        $display("\n--- DCT input Stage 3 ---");
        $display("r0=%d", r0);
        $display("r1=%d", r1);
        $display("r2=%d", r2);
        $display("r3=%d", r3);
        $display("r4=%d", r4);
        $display("r5=%d", r5);
        $display("r6=%d", r6);
        $display("r7=%d", r7);
        $display("------------------\n");
        $display("\n--- DCT Output Stage 3 ---");
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
