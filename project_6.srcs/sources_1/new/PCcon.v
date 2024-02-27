`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 20:28:08
// Design Name: 
// Module Name: PCcon
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


module JumpCon(
    input branchE,
    output reg jumpcon
    );
    initial begin
        jumpcon<=0;
    end
    always@(*)begin
       if(branchE)
            jumpcon<=1;
       else 
            jumpcon<=0;
       
    end
endmodule
