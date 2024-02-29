`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/24 19:21:45
// Design Name: 
// Module Name: Mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux2_32bit(
    input[31:0] a,
    input[31:0] b,
    input sel,
    output reg[31:0] out 
    ); 
    always@(*)begin
        out<= sel?a:b;
    end
endmodule

module Mux3_32bit(
    input[31:0] a,
    input[31:0] b,
    input[31:0] c,
    input[1:0] sel,
    output reg[31:0] out
);
    always@(*)begin
        if(sel==2'b00)
            out<=a;
        else if(sel==2'b01)
            out<=b;
        else if(sel==2'b10)
            out<=c;
        else out<=0;
    end
endmodule
