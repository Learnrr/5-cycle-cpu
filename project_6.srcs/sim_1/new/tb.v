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
  wire[31:0]AluResult,RegOutB,MemDataOut,Instruction,InsAddr,nextpc;
  Cpu Cpu(
     .clk(clk),.rst(rst),.AluResult(AluResult),.RegOutB(RegOutB),.MemDataOut(MemDataOut),.Instruction(Instruction),.InsAddr(InsAddr),.nextpc(nextpc)
  );
initial begin
    clk = 0;
    rst<=0;
  #10
   forever #10
    begin
        clk=~clk;
    end
end
endmodule
