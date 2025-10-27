`timescale 1ns / 1ps


module dct_stage4(
    input reset,
    input  clk,
    input  wire signed [10:0] r0, r1,       // integer inputs
    input  wire signed [25:0] r2, r3,
    input  wire signed [25:0] r4, r5, r6, r7,       // Q11.8 inputs
    output reg  signed [10:0] y0, y1,       // passthrough
    output reg  signed [26:0] y5, y6,              // dont know
    output reg  signed [25:0] y2, y3,
    output reg  signed [26:0] y4, y7                // rotated (Q11.8)
);

    //root(2)
    always @(posedge clk) begin
        // passthrough
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
        y0 <= r0;
        y1 <= r1;
        y2 <= r2;
        y3 <= r3;
        y4 <= -r4+r7;
        y7 <= r4+r7;
        y5<=(r5<<<1)-(r5>>>1)-(r5>>>3)+(r5>>>5)+(r5>>>7)+(r5>>>13);
        y6<=(r6<<<1)-(r6>>>1)-(r6>>>3)+(r6>>>5)+(r6>>>7)+(r6>>>13);
        end
         $display("\n--- DCT input Stage 4 ---");
        $display("r0=%d", r0);
        $display("r1=%d", r1);
        $display("r2=%d", r2);
        $display("r3=%d", r3);
        $display("r4=%d", r4);
        $display("r5=%d", r5);
        $display("r6=%d", r6);
        $display("r7=%d", r7);
        $display("------------------\n");
        $display("\n--- DCT Output Stage 4 ---");
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

