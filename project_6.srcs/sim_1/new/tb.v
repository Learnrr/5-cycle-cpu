`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 18:08:03
// Design Name: 
// Module Name: tb
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


module tb();
  reg clk,rst;
  wire[6:0] LEDL,LEDL1;
  wire[7:0] sel;
  wire[31:0]AluResult,RegOutB,MemDataOut,Instruction;
    Cpu Cpu(
     .clk(clk),.rst(rst),.AluResult(AluResult),.RegOutB(RegOutB),
     .MemDataOut(MemDataOut),.Instruction(Instruction)
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
