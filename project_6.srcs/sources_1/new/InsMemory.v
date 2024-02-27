`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 16:57:51
// Design Name: 
// Module Name: InsMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ���������ָ���ַ�ڴ洢����ȡ��ָ��
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InsMemory(
    input[31:0] InsAddr,                //ָ���ַ
    output reg[31:0] Instruction        //��ȡ��ָ��
    ); 
    parameter length=71;
    reg[7:0] InsMem[0:length];             //ָ��ռ�
   
    integer i;
  initial begin                     //��ʼ��
  //test1:
  //test2:
  $readmemb("D:/test2.txt",InsMem,0,length); 
  //test:
  //
  //test2:   
 //lw r1                            r1=00010203
 //lw r2                            r2=04050607
 //lw r3                             r3=08090a0b
 //lb r4                             r4=0000000d
 //lb r5                            r5=00000003
 //add r6,r5,r1                     ��lb r5�������ݳ�ͻ r6=r1+r5=00010203+0000003=00010206
 //slt r2,r7,r1                      r1=00010203 r7=00000000  r7<r1  r2=00000001
 //addi r7,r6,imm                   r6=00010206 imm=00000000 r7=r6+imm=00010206+00000000=00010206
 //sw r3 [r0+imm]                    r3=08090a0b
 //add r8 r6,r7                      ��addi r7,r6,imm������ͻ  r6=000102006 r7=00010206 r8=r6+r7=0002040c
 //add r9 r8,r1                     ��add r8 r6,r7 ������ͻ  r1=00010203  r8=0002040c  r9=0003060f
 //add r10 r9,r8                     ��addi r7,r6,imm & add r8 r6,r7��ͻ r8=0002040c r9=0003060f r10=00050a1b
 //beq r1 r2   ->insMem[0]             taken
 //lb r4    r4=0000000d                 //��Чָ�as bne is taken
 //lb r5    r5=00000003                 //��Чָ�as bne is taken
    end
    

    always@(InsAddr)begin               //���ֽڶ�ȡָ��
        Instruction[7:0]<=InsMem[InsAddr];
        Instruction[15:8]<=InsMem[InsAddr+1];
        Instruction[23:16]<=InsMem[InsAddr+2];
        Instruction[31:24]<=InsMem[InsAddr+3];
    end    
   
endmodule
