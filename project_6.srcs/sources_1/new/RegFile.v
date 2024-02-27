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
    input clk,                  //s时钟信号
    input we,                   //写使能
    input[4:0] rs1,             //端口1
    input[4:0] rs2,             //端口2
    input[4:0] rd,              //端口3
    input[31:0] InData,         //写入的数据
    output reg[31:0] OutDataA,  //读数据1
    output reg[31:0] OutDataB   //读数据2
    );    
    reg[31:0] Reg[31:0];//32个32位寄存器
    
    integer i;
    initial begin//全部寄存器初始化为0
        for(i=0;i<32;i=i+1)
            Reg[i]=0;
    end
    
    always@(*)begin//读，总是读取，但数据是否写入由控制信号决定，所以不用担心读的数据会写入某些地方
        OutDataA <= Reg[rs1];    
        OutDataB <= Reg[rs2]; 
    end
    
    always@(posedge clk)begin//上升沿写，在时钟上升沿写入数据
        if(we)begin
            Reg[rd]<=InData;       
        end
    end
      
endmodule
