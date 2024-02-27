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
    clk,rst,AluResult,RegOutB,MemDataOut,Instruction,InsAddr,nextpc
    );
    input clk,rst;
    output AluResult,RegOutB,MemDataOut,Instruction,InsAddr,nextpc;
    wire[31:0] Instruction,InsAddr;
    wire Con_signal_Jump,Con_signal_memRead,Con_signal_MemtoReg,Con_signal_MemWrite,Con_signal_AluSrc,Con_signal_RegWrite,Con_signal_pcReset,
    Con_signal_sign,Con_signal_Extop,ZF,CF,OF,branchE;
    wire[31:0]pcadd4,RegOutA,RegOutB,AluResult,ExtImm,AluSrcMuxOut,MemDataOut,MemtoRegMuxOut,BranchMuxOut,JumpMuxOut,BranchMuxA,JumpMuxA;
    wire[2:0] Con_signal_BranchType;
    wire[3:0] Con_signal_Memsel;
    wire[4:0] Con_signal_Aluop;
    
    //IF_ID
    wire[31:0]IF_ID_instruction_out,IF_ID_pcadd4_out,IF_ID_pc_out;
   //ID_EX
   wire[4:0] ID_EX_rd_out;
   wire[31:0] ID_EX_RegOutA_out,ID_EX_RegOutB_out,ID_EX_extout_out,ID_EX_pcadd4_out;
   wire ID_EX_Cs_sign_out,ID_EX_Cs_jump_out,ID_EX_Cs_MemtoReg_out,ID_EX_Cs_MemRead_out,ID_EX_Cs_MemWrite_out,ID_EX_Cs_AluSrc_out,ID_EX_Cs_RegWrite_out,ID_EX_Cs_pcReset_out;
   wire[2:0] ID_EX_Cs_branchType_out;
   wire[4:0] ID_EX_Cs_Aluop_out;
   wire[3:0] ID_EX_Cs_Mem_sel_out;
   //EX_MEM
   wire  EX_MEM_Cs_sign_out,EX_MEM_Cs_MemWrite_out,EX_MEM_Cs_MemtoReg_out,EX_MEM_Cs_MemRead_out,EX_MEM_Cs_RegWrite_out;
   wire[3:0]EX_MEM_Cs_Mem_sel_out;
   wire[4:0] EX_MEM_rd_out;
   wire[31:0] EX_MEM_AluResult_out,EX_MEM_RegOutB_out,EX_MEM_jumpAddr_out;
   //MEM_WB
   wire MEM_WB_Cs_MemtoReg_out,MEM_WB_Cs_RegWrite_out;
   wire[4:0] MEM_WB_rd_out;
   wire[31:0] MEM_WB_AluResult_out,MEM_WB_jumpAddr_out,MEM_WB_MemDataout_out;
   
 //data forwarding
    wire[1:0] s1,s3;
    wire[1:0] ID_EX_s1_out,ID_EX_s3_out;
    wire[31:0] Mux3_Reg1_out,Mux3_Reg2_out;   
    wire clear,lw_stall;
    
    //control hazard
    //没有将分支判断提前，所以要损失三个周期
    //分支指令执行阶段得出结果，如果分支成功产生clear（jumpcon）信号清空 IF_ID, ID_EX, ConUnit
    //使用jumpcon来判断是否产生clear信号，分为两种情况
    //1. 起始状态流水线未执行到EX周期，此时branchE信号为高阻状态
    //2. 得到branchE信号，1 or 0 
    //高阻和0均产生jumpcon = 0, 1产生 jumpcon = 1
    wire[31:0] nextpc;
    wire jumpcon;
    Mux2_32bit PCsrcMux(
        .a(BranchMuxOut),.b(pcadd4),.sel(branchE),.out(nextpc)
    );
 //   JumpCon JumpCon(
  //      .branchE(branchE),.jumpcon(jumpcon)
 //   );
    
    assign BranchMuxA=ID_EX_extout_out;//+ID_EX_pcadd4_out;
  //  assign JumpMuxA=ID_EX_extout_out;//+ID_EX_pcadd4_out;
    
 //   Mux2_32bit JumpMux(
 //       .a(JumpMuxA),.b(BranchMuxOut),.sel(ID_EX_Cs_jump_out),.out(JumpMuxOut)
 //   );
    Mux2_32bit BranchMux(
        .a(BranchMuxA),.b(ID_EX_pcadd4_out),.sel(branchE),.out(BranchMuxOut)
    );
    Mux2_32bit AluSrcMux(
        .a(ID_EX_extout_out),.b(Mux3_Reg2_out),.out(AluSrcMuxOut),.sel(ID_EX_Cs_AluSrc_out)
    );
    Mux2_32bit MemtoRegMux(
        .a(MEM_WB_AluResult_out),.b(MEM_WB_MemDataout_out),.out(MemtoRegMuxOut),.sel(MEM_WB_Cs_MemtoReg_out)
    );
    PC PC(
        .clk(clk),.InPC(nextpc),.InsAddr(InsAddr),.pc_hold(lw_stall)
    );
    PCadd4 PCadd4(
        .pc(InsAddr),.pcadd4(pcadd4)
    );
    InsMemory InsMemory(
        .InsAddr(InsAddr),.Instruction(Instruction)
    );
    RegFile RegFile(
        .clk(clk),.rs1(IF_ID_instruction_out[19:15]),.rs2(IF_ID_instruction_out[24:20]),.rd(MEM_WB_rd_out),.InData(MemtoRegMuxOut),
        .OutDataA(RegOutA),.OutDataB(RegOutB),.we(MEM_WB_Cs_RegWrite_out)
    );
    ConUnit ConUnit(
        .clk(clk),.rst(branchE),
        .Instruction(IF_ID_instruction_out),.Jump(Con_signal_Jump),.BranchType(Con_signal_BranchType),.MemRead(Con_signal_memRead),
        .MemtoReg(Con_signal_MemtoReg),.Aluop(Con_signal_Aluop),.MemWrite(Con_signal_MemWrite),.AluSrc(Con_signal_AluSrc),
        .RegWrite(Con_signal_RegWrite),.pcReset(Con_signal_pcReset),.sign(Con_signal_sign),.Extop(Con_signal_Extop),.Mem_sel(Con_signal_Memsel),
        //data forwarding
        .EX_rd(ID_EX_rd_out),.MEM_rd(EX_MEM_rd_out),.s1(s1),.s3(s3),.RegWrite_EX(ID_EX_Cs_RegWrite_out),.RegWrite_MEM(EX_MEM_Cs_RegWrite_out),
        .clear(clear),.lw_stall(lw_stall),.EX_MemRead(ID_EX_Cs_MemRead_out)
    );
    Ext Ext(
        .sign(Con_signal_Extop),.Instruction(IF_ID_instruction_out),.Imm(ExtImm)
    );
    Alu Alu(
        .Aluop(ID_EX_Cs_Aluop_out),.AluX(Mux3_Reg1_out),.AluY(AluSrcMuxOut),.ZF(ZF),.CF(CF),.OF(OF),.Result(AluResult)
    );
    BranchCon BranchCon(
        .BranchType(ID_EX_Cs_branchType_out),.AluResult(AluResult),.ZF(ZF),.branchE(branchE)
    );
    DataMemory DataMemory(
        .clk(clk),.we(EX_MEM_Cs_MemWrite_out),.re(EX_MEM_Cs_MemRead_out),.sign(EX_MEM_Cs_sign_out),
        .Mem_sel(EX_MEM_Cs_Mem_sel_out),.Addr(EX_MEM_AluResult_out),.InData(EX_MEM_RegOutB_out),.OutData(MemDataOut)
    );
    
    //以下是多周期寄存器
    IF_ID IF_ID(
        //input
        .clk(clk),.IF_instruction(Instruction),.IF_pcadd4(pcadd4),.clear(branchE),.stall(lw_stall),
        //output
        .ID_instruction(IF_ID_instruction_out),.ID_pcadd4(IF_ID_pcadd4_out)
    );
    ID_EX ID_EX(
        //input
        .clk(clk),.ID_rd(IF_ID_instruction_out[11:7]),.ID_RegOutA(RegOutA),.ID_RegOutB(RegOutB),.ID_extout(ExtImm),.clear(branchE),.stall(1'b0),
        .ID_pcadd4(IF_ID_pcadd4_out),.ID_Cs_sign(Con_signal_sign),.ID_Cs_jump(Con_signal_Jump),.ID_Cs_MemtoReg(Con_signal_MemtoReg),
        .ID_Cs_MemRead(Con_signal_memRead),.ID_Cs_MemWrite(Con_signal_MemWrite),.ID_Cs_AluSrc(Con_signal_AluSrc),.ID_Cs_RegWrite(Con_signal_RegWrite),
        .ID_Cs_pcReset(Con_signal_pcReset), .ID_Cs_branchType(Con_signal_BranchType),.ID_Cs_Aluop(Con_signal_Aluop),.ID_Cs_Mem_sel(Con_signal_Memsel),
        //output
        .EX_rd(ID_EX_rd_out),.EX_RegOutA(ID_EX_RegOutA_out),.EX_RegOutB(ID_EX_RegOutB_out),.EX_extout(ID_EX_extout_out),.EX_pcadd4(ID_EX_pcadd4_out),
        .EX_Cs_sign(ID_EX_Cs_sign_out),.EX_Cs_jump(ID_EX_Cs_jump_out),.EX_Cs_MemtoReg(ID_EX_Cs_MemtoReg_out),.EX_Cs_MemRead(ID_EX_Cs_MemRead_out),
        .EX_Cs_MemWrite(ID_EX_Cs_MemWrite_out),.EX_Cs_AluSrc(ID_EX_Cs_AluSrc_out),.EX_Cs_RegWrite(ID_EX_Cs_RegWrite_out),
        .EX_Cs_pcReset(ID_EX_Cs_pcReset_out),.EX_Cs_branchType(ID_EX_Cs_branchType_out),.EX_Cs_Aluop(ID_EX_Cs_Aluop_out),.EX_Cs_Mem_sel(ID_EX_Cs_Mem_sel_out)
        //DATA FORWARDING
         ,.ID_s1(s1),.ID_s3(s3),
        .EX_s1(ID_EX_s1_out),.EX_s3(ID_EX_s3_out)
         
        
    );
    EX_MEM EX_MEM(
        //input
        .clk(clk),.EX_sign(ID_EX_Cs_sign_out),.EX_MemWrite(ID_EX_Cs_MemWrite_out),.EX_MemtoReg(ID_EX_Cs_MemtoReg_out),.EX_MemRead(ID_EX_Cs_MemRead_out),
        .EX_RegWrite(ID_EX_Cs_RegWrite_out),.EX_Cs_Mem_sel(ID_EX_Cs_Mem_sel_out),.EX_rd(ID_EX_rd_out),
        .EX_AluResult(AluResult),.EX_RegOutB(Mux3_Reg2_out),.clear(clear),.stall(1'b0),
        //output
        .MEM_sign(EX_MEM_Cs_sign_out), .MEM_MemWrite(EX_MEM_Cs_MemWrite_out),.MEM_MemtoReg(EX_MEM_Cs_MemtoReg_out),.MEM_MemRead(EX_MEM_Cs_MemRead_out),
        .MEM_RegWrite(EX_MEM_Cs_RegWrite_out),.MEM_Cs_Mem_sel(EX_MEM_Cs_Mem_sel_out),.MEM_rd(EX_MEM_rd_out),
        .MEM_AluResult(EX_MEM_AluResult_out),.MEM_RegOutB(EX_MEM_RegOutB_out)
    );
    MEM_WB MEM_WB(
        //input
        .clk(clk),.MEM_MemtoReg(EX_MEM_Cs_MemtoReg_out),.MEM_RegWrite(EX_MEM_Cs_RegWrite_out),.MEM_rd(EX_MEM_rd_out),
        .MEM_MemDataout(MemDataOut),.MEM_AluResult(EX_MEM_AluResult_out),.clear(clear),.stall(1'b0),
        //output
        .WB_MemtoReg(MEM_WB_Cs_MemtoReg_out),.WB_RegWrite(MEM_WB_Cs_RegWrite_out),.WB_rd(MEM_WB_rd_out),
        .WB_AluResult(MEM_WB_AluResult_out),.WB_MemDataout(MEM_WB_MemDataout_out)
    );
   
    //data forwarding
    Mux3_32bit Mux3_Reg1(
        .sel(ID_EX_s1_out),.a(EX_MEM_AluResult_out),.b(MemtoRegMuxOut),.c(ID_EX_RegOutA_out),.out(Mux3_Reg1_out)
    );
    Mux3_32bit Mux3_Reg2(
        .sel(ID_EX_s3_out),.a(EX_MEM_AluResult_out),.b(MemtoRegMuxOut),.c(ID_EX_RegOutB_out),.out(Mux3_Reg2_out)
    );
    
endmodule

