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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InsMemory(
    input[31:0] InsAddr,                //指令地址
    output reg[31:0] Instruction        //读取的指令
    );
    reg[7:0] InsMem[511:0];             //指令空间
    
    initial begin                       //初始化
    //lw  000000000000_00000_010_00001_0000011    lw r1   00002083
    InsMem[0]=8'b10000011;
    InsMem[1]=8'b00100000;
    InsMem[2]=8'b00000000;
    InsMem[3]=8'b00000000;
    //lw 000000000000_00000_010_00010_0000011 lw r2   00002103
    InsMem[4]=8'b00000011;
    InsMem[5]=8'b00100001;
    InsMem[6]=8'b00000000;
    InsMem[7]=8'b00000000;
    //add 0000000_00010_00001_000_00011_0110011 add r3,r1,r2  002081B3
    InsMem[8]=8'b10110011;
    InsMem[9]=8'b10000001;
    InsMem[10]=8'b00100000;
    InsMem[11]=8'b00000000;
    //lb 000000000000_00000_000_00100_0000011 lb r4     00000203
    InsMem[12]=8'b00000011;
    InsMem[13]=8'b00000010;
    InsMem[14]=8'b00000000;
    InsMem[15]=8'b00000000;
    //lb 000000000000_00000_000_00101_0000011 lb r5     00000283
    InsMem[16]=8'b10000011;
    InsMem[17]=8'b00000010;
    InsMem[18]=8'b00000000;
    InsMem[19]=8'b00000000;
     //add 0000000_00100_00101_000_00110_0110011 add r6,r4,r5    00428333
    InsMem[20]=8'b00110011;
    InsMem[21]=8'b10000011;
    InsMem[22]=8'b01000010;
    InsMem[23]=8'b00000000;
    //slt 0000000_00001_00100_010_00010_0110011 slt r2,r4,r1     00122133
    InsMem[24]=8'b00110011;
    InsMem[25]=8'b00100001;
    InsMem[26]=8'b00010010;
    InsMem[27]=8'b00000000;
    //addi 000000000000_00110_000_00111_0010011 addi r7,r4,imm     00030393
    InsMem[28]=8'b10010011;
    InsMem[29]=8'b00000011;
    InsMem[30]=8'b00000011;
    InsMem[31]=8'b00000000;
    //sltiu 000000000000_00111_011_01000_0010011 sltiu r8,r7,imm     0003b413
    InsMem[32]=8'b00010011;
    InsMem[33]=8'b10110100;
    InsMem[34]=8'b00000011;
    InsMem[35]=8'b00000000;
    //sw 0000000_00011_00000_010_00000_0100011 sw r3 [r0+imm]       00302023
    InsMem[36]=8'b00100011;
    InsMem[37]=8'b00100000;
    InsMem[38]=8'b00110000;
    InsMem[39]=8'b00000000;
    //bne 0000000_00001_00111_001_10000_1100011 bne r1,r7,imm        00139863
    InsMem[40]=8'b01100011;
    InsMem[41]=8'b10011000;
    InsMem[42]=8'b00010011;
    InsMem[43]=8'b00000000;
    end
    
    
    always@(InsAddr)begin               //按字节读取指令
        Instruction[7:0]<=InsMem[InsAddr];
        Instruction[15:8]<=InsMem[InsAddr+1];
        Instruction[23:16]<=InsMem[InsAddr+2];
        Instruction[31:24]<=InsMem[InsAddr+3];
    end
   
endmodule
