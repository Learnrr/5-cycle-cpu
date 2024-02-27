`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/19 17:38:05
// Design Name: 
// Module Name: IF_Jump
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
//在IF段根据Ins判断是否是Jump指令，传出写入的rd，下一个取指地址，pcadd4向后传，别忘记在ConUnit中给出rd的RegWrite信号

module IF_Jump(
    input[31:0] Instruction,
    output reg IsJ,
    output reg[4:0] Jrd,
    output reg[31:0] JAddr
    );
    initial begin
        IsJ<=0;
        JAddr<=0;
    end
    always@(Instruction)begin
        
    end
    
endmodule
