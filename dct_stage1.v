
//NO change input from 0 to 255
//output from the range of 0 to 510
module dct_stage1 (
    input reset,
    input clk,
    input  signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    output reg signed [8:0] r0, r1, r2, r3, r4, r5, r6, r7
);
    always @(posedge clk) begin
    if(reset)begin
        r0 <= 0;
        r7 <= 0;
        r1 <= 0;
        r6 <= 0;
        r2 <= 0;
        r5 <= 0;
        r3 <= 0;
        r4 <= 0;
    end
    else begin
        r0 <= x0 + x7;
        r7 <= x0 - x7;
        r1 <= x1 + x6;
        r6 <= x1 - x6;
        r2 <= x2 + x5;
        r5 <= x2 - x5;
        r3 <= x3 + x4;
        r4 <= x3 - x4;
    end
    end
endmodule
