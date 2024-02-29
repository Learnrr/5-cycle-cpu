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
    
    //IF_ID
    wire[31:0]IF_ID_instruction_out,IF_ID_pcadd4_out;
   //ID_EX
   wire[4:0] ID_EX_rd_out;
   wire[31:0] ID_EX_RegOutA_out,ID_EX_RegOutB_out,ID_EX_extout_out,ID_EX_pcadd4_out;
   wire ID_EX_Cs_sign_out,ID_EX_Cs_jump_out,ID_EX_Cs_MemtoReg_out,ID_EX_Cs_MemRead_out,ID_EX_Cs_MemWrite_out,ID_EX_Cs_AluSrc_out,ID_EX_Cs_RegWrite_out,ID_EX_Cs_pcReset_out;
   wire[2:0] ID_EX_Cs_branchType_out;
   wire[4:0] ID_EX_Cs_Aluop_out;
   wire[3:0] ID_EX_Cs_Mem_sel_out;
   //EX_MEM
   wire  EX_MEM_sign_out,EX_MEM_MemWrite_out,EX_MEM_MemtoReg_out,EX_MEM_MemRead_out,EX_MEM_RegWrite_out,EX_MEM_pcReset_out;
   wire[3:0]EX_MEM_Cs_Mem_sel_out;
   wire[4:0] EX_MEM_rd_out;
   wire[31:0] EX_MEM_AluResult_out,EX_MEM_RegOutB_out,EX_MEM_jumpAddr_out;
   //MEM_WB
   wire MEM_WB_MemtoReg_out,MEM_WB_RegWrite_out,MEM_WB_pcReset_out;
   wire[4:0] MEM_WB_rd_out;
   wire[31:0] MEM_WB_AluResult_out,MEM_WB_jumpAddr_out,MEM_WB_MemDataout_out;
   //pc delay
   wire[31:0] pc_delay_out;
   
    assign BranchMuxA=ID_EX_extout_out+ID_EX_pcadd4_out;
    assign JumpMuxA=ID_EX_extout_out+ID_EX_pcadd4_out;
    
    Mux2_32bit JumpMux(
        .a(JumpMuxA),.b(BranchMuxOut),.sel(ID_EX_Cs_jump_out),.out(JumpMuxOut)
    );
    Mux2_32bit BranchMux(
        .a(BranchMuxA),.b(ID_EX_pcadd4_out),.sel(branchE),.out(BranchMuxOut)
    );
    Mux2_32bit AluSrcMux(
        .a(ID_EX_extout_out),.b(ID_EX_RegOutB_out),.out(AluSrcMuxOut),.sel(ID_EX_Cs_AluSrc_out)
    );
    Mux2_32bit MemtoRegMux(
        .a(MEM_WB_AluResult_out),.b(MEM_WB_MemDataout_out),.out(MemtoRegMuxOut),.sel(MEM_WB_MemtoReg_out)
    );
    PC PC(
        .clk(clk),.InPC(MEM_WB_jumpAddr_out),.InsAddr(InsAddr)
    );
    PCadd4 PCadd4(
        .pc(InsAddr),.pcadd4(pcadd4)
    );
    InsMemory InsMemory(
        .InsAddr(InsAddr),.Instruction(Instruction)
    );
    RegFile RegFile(
        .clk(clk),.rs1(IF_ID_instruction_out[19:15]),.rs2(IF_ID_instruction_out[24:20]),.rd(MEM_WB_rd_out),.InData(MemtoRegMuxOut),
        .OutDataA(RegOutA),.OutDataB(RegOutB),.we(MEM_WB_RegWrite_out)
    );
    ConUnit ConUnit(
        .Instruction(IF_ID_instruction_out),.Jump(Con_signal_Jump),.BranchType(Con_signal_BranchType),.MemRead(Con_signal_memRead),
        .MemtoReg(Con_signal_MemtoReg),.Aluop(Con_signal_Aluop),.MemWrite(Con_signal_MemWrite),.AluSrc(Con_signal_AluSrc),
        .RegWrite(Con_signal_RegWrite),.pcReset(Con_signal_pcReset),.sign(Con_signal_sign),.Extop(Con_signal_Extop),.Mem_sel(Con_signal_Memsel)
    );
    Ext Ext(
        .sign(Con_signal_Extop),.Instruction(IF_ID_instruction_out),.Imm(ExtImm)
    );
    Alu Alu(
        .Aluop(ID_EX_Cs_Aluop_out),.AluX(ID_EX_RegOutA_out),.AluY(AluSrcMuxOut),.ZF(ZF),.CF(CF),.OF(OF),.Result(AluResult)
    );
    BranchCon BranchCon(
        .BranchType(ID_EX_Cs_branchType_out),.AluResult(AluResult),.ZF(ZF),.branchE(branchE)
    );
    DataMemory DataMemory(
        .clk(clk),.we(EX_MEM_MemWrite_out),.re(EX_MEM_MemRead_out),.sign(EX_MEM_sign_out),
        .Mem_sel(EX_MEM_Cs_Mem_sel_out),.Addr(EX_MEM_AluResult_out),.InData(EX_MEM_RegOutB_out),.OutData(MemDataOut)
    );
    
    //以下是多周期寄存器
    IF_ID IF_ID(
        //input
        .clk(clk),.IF_instruction(Instruction),.IF_pcadd4(pcadd4),
        //output
        .ID_instruction(IF_ID_instruction_out),.ID_pcadd4(IF_ID_pcadd4_out)
    );
    ID_EX ID_EX(
        //input
        .clk(clk),.ID_rd(IF_ID_instruction_out[11:7]),.ID_RegOutA(RegOutA),.ID_RegOutB(RegOutB),.ID_extout(ExtImm),
        .ID_pcadd4(IF_ID_pcadd4_out),.ID_Cs_sign(Con_signal_sign),.ID_Cs_jump(Con_signal_Jump),.ID_Cs_MemtoReg(Con_signal_MemtoReg),
        .ID_Cs_MemRead(Con_signal_memRead),.ID_Cs_MemWrite(Con_signal_MemWrite),.ID_Cs_AluSrc(Con_signal_AluSrc),.ID_Cs_RegWrite(Con_signal_RegWrite),
        .ID_Cs_pcReset(Con_signal_pcReset), .ID_Cs_branchType(Con_signal_BranchType),.ID_Cs_Aluop(Con_signal_Aluop),.ID_Cs_Mem_sel(Con_signal_Memsel),
        //output
        .EX_rd(ID_EX_rd_out),.EX_RegOutA(ID_EX_RegOutA_out),.EX_RegOutB(ID_EX_RegOutB_out),.EX_extout(ID_EX_extout_out),.EX_pcadd4(ID_EX_pcadd4_out),
        .EX_Cs_sign(ID_EX_Cs_sign_out),.EX_Cs_jump(ID_EX_Cs_jump_out),.EX_Cs_MemtoReg(ID_EX_Cs_MemtoReg_out),.EX_Cs_MemRead(ID_EX_Cs_MemRead_out),
        .EX_Cs_MemWrite(ID_EX_Cs_MemWrite_out),.EX_Cs_AluSrc(ID_EX_Cs_AluSrc_out),.EX_Cs_RegWrite(ID_EX_Cs_RegWrite_out),
        .EX_Cs_pcReset(ID_EX_Cs_pcReset_out),.EX_Cs_branchType(ID_EX_Cs_branchType_out),.EX_Cs_Aluop(ID_EX_Cs_Aluop_out),.EX_Cs_Mem_sel(ID_EX_Cs_Mem_sel_out)
    );
    EX_MEM EX_MEM(
        //input
        .clk(clk),.EX_sign(ID_EX_Cs_sign_out),.EX_MemWrite(ID_EX_Cs_MemWrite_out),.EX_MemtoReg(ID_EX_Cs_MemtoReg_out),.EX_MemRead(ID_EX_Cs_MemRead_out),
        .EX_RegWrite(ID_EX_Cs_RegWrite_out),.EX_pcReset(ID_EX_Cs_pcReset_out),.EX_Cs_Mem_sel(ID_EX_Cs_Mem_sel_out),.EX_rd(ID_EX_rd_out),
        .EX_AluResult(AluResult),.EX_RegOutB(ID_EX_RegOutB_out),.EX_jumpAddr(JumpMuxOut),
        //output
        .MEM_sign(EX_MEM_sign_out), .MEM_MemWrite(EX_MEM_MemWrite_out),.MEM_MemtoReg(EX_MEM_MemtoReg_out),.MEM_MemRead(EX_MEM_MemRead_out),
        .MEM_RegWrite(EX_MEM_RegWrite_out),.MEM_pcReset(EX_MEM_pcReset_out),.MEM_Cs_Mem_sel(EX_MEM_Cs_Mem_sel_out),.MEM_rd(EX_MEM_rd_out),
        .MEM_AluResult(EX_MEM_AluResult_out),.MEM_RegOutB(EX_MEM_RegOutB_out),.MEM_jumpAddr(EX_MEM_jumpAddr_out)
    );
    MEM_WB MEM_WB(
        //input
        .clk(clk),.MEM_MemtoReg(EX_MEM_MemtoReg_out),.MEM_RegWrite(EX_MEM_RegWrite_out),.MEM_pcReset(EX_MEM_pcReset_out),.MEM_rd(EX_MEM_rd_out),
        .MEM_MemDataout(MemDataOut),.MEM_AluResult(EX_MEM_AluResult_out),.MEM_jumpAddr(EX_MEM_jumpAddr_out),
        //output
        .WB_MemtoReg(MEM_WB_MemtoReg_out),.WB_RegWrite(MEM_WB_RegWrite_out),.WB_pcReset(MEM_WB_pcReset_out),.WB_rd(MEM_WB_rd_out),
        .WB_AluResult(MEM_WB_AluResult_out),.WB_jumpAddr(MEM_WB_jumpAddr_out),.WB_MemDataout(MEM_WB_MemDataout_out)
    );
    
    wire[1:0] s1,s3;
    //data forwarding
    Mux3_32bit Mux3_Reg1(
        .sel(s1),.a(AluResult),.b(MemDataOut),.c(RegOutA)
    );
    Mux3_32bit Mux3_Reg2(
        .sel(s3),.a(AluResult),.b(MemDataOut),.c(RegOutB)
    );
    
endmodule

