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
//��IF�θ���Ins�ж��Ƿ���Jumpָ�����д���rd����һ��ȡָ��ַ��pcadd4��󴫣���������ConUnit�и���rd��RegWrite�ź�

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
