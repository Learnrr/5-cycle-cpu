`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 22:48:22
// Design Name: 
// Module Name: 
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


module IF_ID(
    input clk,
    input clear,
    input stall,
    input[31:0] IF_instruction,
    input[31:0] IF_pcadd4,
    output[31:0] ID_instruction,
    output[31:0] ID_pcadd4
    );

dff_32 dff_instruction(
    .clk(clk),.d(IF_instruction),.q(ID_instruction),.clear(clear),.stall(stall)
);
dff_32 dff_pcadd4(
    .clk(clk),.d(IF_pcadd4),.q(ID_pcadd4),.clear(clear),.stall(stall)
);    
endmodule

module ID_EX(
    input clk,
    input stall,
    input clear,
    input[4:0]ID_rd,
    input[31:0] ID_RegOutA,ID_RegOutB,ID_extout,ID_pcadd4,
    input ID_Cs_sign,ID_Cs_jump,ID_Cs_MemtoReg,ID_Cs_MemRead,ID_Cs_MemWrite,ID_Cs_AluSrc,ID_Cs_RegWrite,ID_Cs_pcReset,
    input[2:0] ID_Cs_branchType,
    input[4:0] ID_Cs_Aluop,
    input[3:0] ID_Cs_Mem_sel,
    
    output[4:0] EX_rd,
    output[31:0] EX_RegOutA,EX_RegOutB,EX_extout,EX_pcadd4,
    output EX_Cs_sign,EX_Cs_jump,EX_Cs_MemtoReg,EX_Cs_MemRead,EX_Cs_MemWrite,EX_Cs_AluSrc,EX_Cs_RegWrite,EX_Cs_pcReset,
    output[2:0]EX_Cs_branchType,
    output[4:0] EX_Cs_Aluop,
    output[3:0] EX_Cs_Mem_sel,
    
    input[1:0]ID_s1,ID_s3,
    output[1:0] EX_s1,EX_s3
  
);
dff_2 dff_s1(
    .clk(clk),.d(ID_s1),.q(EX_s1),.clear(clear),.stall(stall)
);
dff_2 dff_s3(
    .clk(clk),.d(ID_s3),.q(EX_s3),.clear(clear),.stall(stall)
);
dff_32 dff_RegOutA(
    .clk(clk),.d(ID_RegOutA),.q(EX_RegOutA),.clear(clear),.stall(stall)
);
dff_32 dff_RegOutB(
    .clk(clk),.d(ID_RegOutB),.q(EX_RegOutB),.clear(clear),.stall(stall)
);
dff_32 dff_extout(
    .clk(clk),.d(ID_extout),.q(EX_extout),.clear(clear),.stall(stall)
);
dff_32 dff_pcadd4(
    .clk(clk),.d(ID_pcadd4),.q(EX_pcadd4),.clear(clear),.stall(stall)
);
dff_5 dff_rd(
    .clk(clk),.d(ID_rd),.q(EX_rd),.clear(clear),.stall(stall)
);
dff_5 dff_Aluop(
    .clk(clk),.d(ID_Cs_Aluop),.q(EX_Cs_Aluop),.clear(clear),.stall(stall)
);
dff dff_sign(
    .clk(clk),.d(ID_Cs_sign),.q(EX_Cs_sign),.clear(clear),.stall(stall)
);
dff dff_jump(
    .clk(clk),.d(ID_Cs_jump),.q(EX_Cs_jump),.clear(clear),.stall(stall)
);
dff dff_MemtoReg(
    .clk(clk),.d(ID_Cs_MemtoReg),.q(EX_Cs_MemtoReg),.clear(clear),.stall(stall)
);
dff dff_MemRead(
    .clk(clk),.d(ID_Cs_MemRead),.q(EX_Cs_MemRead),.clear(clear),.stall(stall)
);
dff dff_MemWrite(
    .clk(clk),.d(ID_Cs_MemWrite),.q(EX_Cs_MemWrite),.clear(clear),.stall(stall)
);
dff dff_AluSrc(
    .clk(clk),.d(ID_Cs_AluSrc),.q(EX_Cs_AluSrc),.clear(clear),.stall(stall)
);
dff dff_RegWrite(
    .clk(clk),.d(ID_Cs_RegWrite),.q(EX_Cs_RegWrite),.clear(clear),.stall(stall)
);
dff dff_pcReset(
    .clk(clk),.d(ID_Cs_pcReset),.q(EX_Cs_pcReset),.clear(clear),.stall(stall)
);
dff_3 dff_branchType(
    .clk(clk),.d(ID_Cs_branchType),.q(EX_Cs_branchType),.clear(clear),.stall(stall)
);
dff_4 dff_Mem_sel(
    .clk(clk),.d(ID_Cs_Mem_sel),.q(EX_Cs_Mem_sel),.clear(clear),.stall(stall)
);
endmodule

module EX_MEM(
    input clk,
    input clear,
    input stall,
    input EX_sign,EX_MemWrite,EX_MemtoReg,EX_MemRead,EX_RegWrite,
    input[3:0] EX_Cs_Mem_sel,
    input[4:0] EX_rd,
    input[31:0] EX_AluResult,EX_RegOutB,
    
    output MEM_sign, MEM_MemWrite,MEM_MemtoReg,MEM_MemRead,MEM_RegWrite,
    output[3:0] MEM_Cs_Mem_sel,
    output [4:0] MEM_rd,
    output [31:0] MEM_AluResult,MEM_RegOutB
);

dff dff_MemWrite(
    .clk(clk),.d(EX_MemWrite),.q(MEM_MemWrite),.clear(clear),.stall(stall)
);
dff dff_MemtoReg(
    .clk(clk),.d(EX_MemtoReg),.q(MEM_MemtoReg),.clear(clear),.stall(stall)
);
dff dff_MemRead(
    .clk(clk),.d(EX_MemRead),.q(MEM_MemRead),.clear(clear),.stall(stall)
);
dff dff_RegWrite(
    .clk(clk),.d(EX_RegWrite),.q(MEM_RegWrite),.clear(clear),.stall(stall)
);
dff dff_sign(
    .clk(clk),.d(EX_sign),.q(MEM_sign),.clear(clear),.stall(stall)
);
dff_32 dff_RegOutB(
    .clk(clk),.d(EX_RegOutB),.q(MEM_RegOutB),.clear(clear),.stall(stall)
);
dff_32 dff_AluResult(
    .clk(clk),.d(EX_AluResult),.q(MEM_AluResult),.clear(clear),.stall(stall)
);
dff_4 dff_Mem_sel(
    .clk(clk),.d(EX_Cs_Mem_sel),.q(MEM_Cs_Mem_sel),.clear(clear),.stall(stall)
);
dff_5 dff_rd(
    .clk(clk),.d(EX_rd),.q(MEM_rd),.clear(clear),.stall(stall)
);
endmodule

module MEM_WB(
    input clk,
    input clear,
    input stall,
    input MEM_MemtoReg,MEM_RegWrite,MEM_pcReset,
    input[4:0] MEM_rd,
    input[31:0] MEM_MemDataout,MEM_AluResult,
    
    output WB_MemtoReg,WB_RegWrite,WB_pcReset,
    output[4:0]WB_rd,
    output [31:0] WB_AluResult,WB_MemDataout  
);

dff dff_MemtoReg(
    .clk(clk),.d(MEM_MemtoReg),.q(WB_MemtoReg),.clear(clear),.stall(stall)
);
dff dff_RegWrite(
    .clk(clk),.d(MEM_RegWrite),.q(WB_RegWrite),.clear(clear),.stall(stall)
);
dff dff_pcReset(
    .clk(clk),.d(MEM_pcReset),.q(WB_pcReset),.clear(clear),.stall(stall)
);
dff_5 dff_rd(
    .clk(clk),.d(MEM_rd),.q(WB_rd),.clear(clear),.stall(stall)
);
dff_32 dff_MemDataout(
    .clk(clk),.d(MEM_MemDataout),.q(WB_MemDataout),.clear(clear),.stall(stall)
);
dff_32 dff_AluResult(
    .clk(clk),.d(MEM_AluResult),.q(WB_AluResult),.clear(clear),.stall(stall)
);
endmodule


