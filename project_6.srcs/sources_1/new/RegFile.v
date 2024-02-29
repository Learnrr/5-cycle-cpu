`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 16:29:05
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk,                  //sʱ���ź�
    input we,                   //дʹ��
    input[4:0] rs1,             //�˿�1
    input[4:0] rs2,             //�˿�2
    input[4:0] rd,              //�˿�3
    input[31:0] InData,         //д�������
    output reg[31:0] OutDataA,  //������1
    output reg[31:0] OutDataB   //������2
    );    
    reg[31:0] Reg[31:0];//32��32λ�Ĵ���
    
    integer i;
    initial begin//ȫ���Ĵ�����ʼ��Ϊ0
        for(i=0;i<32;i=i+1)
            Reg[i]=0;
    end
    
    always@(*)begin//��
        OutDataA <= Reg[rs1];    
        OutDataB <= Reg[rs2]; 
    end
    
    always@(posedge clk)begin//������д
        if(we)begin
            Reg[rd]<=InData;       
        end
    end
      
endmodule
