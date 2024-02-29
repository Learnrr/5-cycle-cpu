`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 16:28:36
// Design Name: 
// Module Name: Cpu
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

module Cpu(
    clk,rst,AluResult,RegOutB,MemDataOut,Instruction
    );
    input clk,rst;
    output AluResult,RegOutB,MemDataOut,Instruction;
    wire[31:0] Instruction;
    wire Con_signal_Jump,Con_signal_memRead,Con_signal_MemtoReg,Con_signal_MemWrite,Con_signal_AluSrc,Con_signal_RegWrite,Con_signal_pcReset,
    Con_signal_sign,Con_signal_Extop,ZF,CF,OF,branchE;
    wire[31:0]pcadd4,InsAddr,RegOutA,RegOutB,AluResult,ExtImm,AluSrcMuxOut,MemDataOut,MemtoRegMuxOut,BranchMuxOut,JumpMuxOut,BranchMuxA,JumpMuxA;
    wire[2:0] Con_signal_BranchType;
    wire[3:0] Con_signal_Memsel;
    wire[4:0] Con_signal_Aluop;
    
   
    assign BranchMuxA=ExtImm+pcadd4;
    assign JumpMuxA=ExtImm+pcadd4;
    
   Mux2_32bit JumpMux(
        .a(JumpMuxA),.b(BranchMuxOut),.sel(Con_signal_Jump),.out(JumpMuxOut)
   );
    Mux2_32bit BranchMux(
        .a(BranchMuxA),.b(pcadd4),.sel(branchE),.out(BranchMuxOut)
    );
    Mux2_32bit AluSrcMux(
        .a(ExtImm),.b(RegOutB),.out(AluSrcMuxOut),.sel(Con_signal_AluSrc)
    );
    Mux2_32bit MemtoRegMux(
        .a(AluResult),.b(MemDataOut),.out(MemtoRegMuxOut),.sel(Con_signal_MemtoReg)
    );
    PC PC(
        .clk(clk),.InPC(JumpMuxOut),.InsAddr(InsAddr)
    );
    PCadd4 PCadd4(
        .pc(InsAddr),.pcadd4(pcadd4)
    );
    InsMemory InsMemory(
        .InsAddr(InsAddr),.Instruction(Instruction)
    );
    RegFile RegFile(
        .clk(clk),.rs1(Instruction[19:15]),.rs2(Instruction[24:20]),.rd(Instruction[11:7]),.InData(MemtoRegMuxOut),
        .OutDataA(RegOutA),.OutDataB(RegOutB),.we(Con_signal_RegWrite)
    );
    ConUnit ConUnit(
        .Instruction(Instruction),.Jump(Con_signal_Jump),.BranchType(Con_signal_BranchType),.MemRead(Con_signal_memRead),
        .MemtoReg(Con_signal_MemtoReg),.Aluop(Con_signal_Aluop),.MemWrite(Con_signal_MemWrite),.AluSrc(Con_signal_AluSrc),
        .RegWrite(Con_signal_RegWrite),.pcReset(Con_signal_pcReset),.sign(Con_signal_sign),.Extop(Con_signal_Extop),.Mem_sel(Con_signal_Memsel)
    );
    Ext Ext(
        .sign(Con_signal_Extop),.Instruction(Instruction),.Imm(ExtImm)
    );
    Alu Alu(
        .Aluop(Con_signal_Aluop),.AluX(RegOutA),.AluY(AluSrcMuxOut),.ZF(ZF),.CF(CF),.OF(OF),.Result(AluResult)
    );
    BranchCon BranchCon(
        .BranchType(Con_signal_BranchType),.AluResult(AluResult),.ZF(ZF),.branchE(branchE)
    );
    DataMemory DataMemory(
        .clk(clk),.we(Con_signal_MemWrite),.re(Con_signal_memRead),.sign(Con_signal_sign),
        .Mem_sel(Con_signal_Memsel),.Addr(AluResult),.InData(RegOutB),.OutData(MemDataOut)
    );
endmodule

