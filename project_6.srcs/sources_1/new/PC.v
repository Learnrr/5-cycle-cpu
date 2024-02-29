`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 16:49:22
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input[31:0] InPC,
    output reg[31:0] InsAddr
    );
    
    initial begin
        InsAddr<=-4;
    end
    
    always@(posedge clk)begin
        if(InsAddr==-4)
            InsAddr<=InsAddr+4;
        else InsAddr<=InPC;   
    end
    
endmodule
