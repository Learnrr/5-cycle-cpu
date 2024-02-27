`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 15:57:20
// Design Name: 
// Module Name: main_tb
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


module main_tb();
   reg clk,rst; 
    wire[6:0]  LEDL,LEDL1;
    wire[7:0] sel;
    MAIN MAIN(
        .clk(clk),.rst(rst),.LEDL(LEDL),.LEDL1(LEDL1),.sel(sel)
    );
    initial begin
    clk = 0;
  #10
   forever #10
    begin
        clk=~clk;
    end
end
endmodule
