`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 20:44:38
// Design Name: 
// Module Name: ConUnit
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


 module ConUnit(
    input clk,
    input[31:0] Instruction,
    input rst,
    
    output reg Jump,            //跳转
    output reg[2:0] BranchType, //branch类型
    output reg MemRead,         //读存储器
    output reg MemtoReg,        //ALU- OUT / MEM OUT-> REG
    output reg[4:0] Aluop,      //ALU操作
    output reg MemWrite,        //写存储器
    output reg AluSrc,          //ALUY 的数据来源
    output reg RegWrite,        //写寄存器
    output reg pcReset,         //pc重置
    output reg sign,            //load/store byte/half word时不满32位的数据位符号扩展还是无符号扩展，对应于lhu/lh  lbu/lb
    output reg Extop,           //Ext符号扩展还是无符号扩展
    output reg[3:0]Mem_sel,      //byte / halfword / word
    
    
    // dataforwarding 
    input[4:0] EX_rd, // 执行段要写的寄存器
    input[4:0] MEM_rd,//访存段要写的寄存器
    output reg[1:0]  s1,s3,//s1控制ALUX的数据前推选择器、s3控制ALUY的数据前推选择器
    input RegWrite_EX,RegWrite_MEM,
    //lw 
    input EX_MemRead,//EX、MEM阶段的读存储器信号
    output reg lw_stall,//暂停PC,IF_ID的信号
    output reg clear//清空寄存器
    
    );
    reg[6:0] opcode;
    reg[2:0] funct3;
    reg[6:0] funct7;
    always@(negedge rst)begin
        if(!rst)begin  //lw处理，避免错误导致MemRead=1
                MemRead<=0;
         end
    end
    always@(*)begin      
        opcode <= Instruction[6:0];
        funct3 <= Instruction[14:12];
        funct7 <= Instruction[31:25];        
        case(opcode)
            7'b0110011:begin//R-TYPE
                Jump<=0;
                BranchType<=3'b000;
                MemRead<=0;
                MemtoReg<=1;//ALU
                MemWrite<=0;
                AluSrc<=0;//REG
                RegWrite<=1;
                pcReset<=0;
                Extop<=0;
                case({funct3,funct7})
                    10'b000_0000000:begin Aluop<=5'b00001;end//add
                    10'b000_0100000:begin Aluop<=5'b00010;end//sub
                    10'b100_0000000:begin Aluop<=5'b00111;end//xor
                    10'b110_0000000:begin Aluop<=5'b00110;end//or
                    10'b111_0000000:begin Aluop<=5'b00101;end//and
                    10'b001_0000000:begin Aluop<=5'b01000;end//sll
                    10'b101_0000000:begin Aluop<=5'b01001;end//srl
                    10'b101_0100000:begin Aluop<=5'b01011;end//sra
                    10'b010_0000000:begin Aluop<=5'b01100;end//slt
                    10'b011_0000000:begin Aluop<=5'b01101;end//sltu
                    10'b000_0000001:begin Aluop<=5'b10000;end// mul
                    10'b001_0000001:begin Aluop<=5'b10001;end// mulh
                    10'b100_0000001:begin Aluop<=5'b10001;end// div 
                    10'b101_0000001:begin Aluop<=5'b10001;end// divu   
                endcase
           end
           7'b0010011:begin//I-TYPE
                Jump<=0;
                BranchType<=3'b000;
                MemRead<=0;
                MemtoReg<=1;//ALU
                MemWrite<=0;
                AluSrc<=1;//EXT
                RegWrite<=1;
                pcReset<=0;
                Extop<=0;
                Mem_sel<=4'b1111;//32位
                case(funct3)
                    3'b000:begin Aluop<=5'b00001;end//addi
                    3'b100:begin Aluop<=5'b00111;end//xori
                    3'b110:begin Aluop<=5'b00110;end//ori
                    3'b111:begin Aluop<=5'b00101;end//andi
                    3'b001:begin Aluop<=5'b01000;end//slli 
                    3'b101:begin                    
                        if(Instruction[31:25]==7'b0000000)begin//srli 
                            Aluop<=5'b01001;
                            MemtoReg<=1'b1;//ALU
                        end
                        else begin
                            Aluop<=5'b01011;//srai 
                            MemtoReg<=1;//ALU
                        end
                    end
                    3'b010:begin Aluop<=5'b01100;end//slti
                    3'b011:begin Aluop<=5'b01101;end//sltiu
                endcase
            end
            7'b0000011:begin//I-TYPE LOAD
                Jump<=0;
                BranchType<=3'b000;
                MemRead<=1;
                MemtoReg<=0;//MEM
                MemWrite<=0;
                AluSrc<=1;//EXT
                RegWrite<=1;
                pcReset<=0;
                Extop<=1;
                Aluop<=5'b000001;
                case(funct3)
                    3'b000:begin Mem_sel<=4'b0001;sign<=1;end//lb
                    3'b001:begin Mem_sel<=4'b0011;sign<=1;end//lh
                    3'b010:begin Mem_sel<=4'b1111;sign<=1;end//lw
                    3'b100:begin Mem_sel<=4'b0001;sign<=0;end//lbu
                    3'b101:begin Mem_sel<=4'b0011;sign<=0;end//lhu
                endcase
            end
            7'b0100011:begin//S-TYPE
                Jump<=0;
                BranchType<=3'b000;
                MemRead<=0;    
                MemWrite<=1;
                AluSrc<=1;//EXT
                RegWrite<=0;
                pcReset<=0;
                Aluop<=5'b000001;
                Extop<=0;
                case(funct3)
                    3'b000:begin Mem_sel<=4'b0001;sign<=1;end//sb
                    3'b001:begin Mem_sel<=4'b0011;sign<=1;end//sh
                    3'b010:begin Mem_sel<=4'b1111;sign<=1;end//sw
                endcase
            end
            7'b1100011:begin//B-TYPE
                Jump<=0;
                MemRead<=0;    
                MemWrite<=0;
                RegWrite<=0;
                pcReset<=0;
                Extop<=0;
                AluSrc<=0;
                case(funct3)
                    3'b000:begin Aluop<=5'b00010;BranchType<=3'b001;end//beq
                    3'b001:begin Aluop<=5'b00010;BranchType<=3'b010;end//bne
                    3'b100:begin Aluop<=5'b01101;BranchType<=3'b011;end//blt
                    3'b101:begin Aluop<=5'b01101;BranchType<=3'b100;end//bge
                    3'b110:begin Aluop<=5'b01100;BranchType<=3'b101;end//bltu
                    3'b111:begin Aluop<=5'b01100;BranchType<=3'b110;end//bgeu
                endcase
            end
            7'b0110111:begin//lui 可以和r类型的指令一样判断hazard
                MemRead<=0;
                MemWrite<=0;
                RegWrite<=1;
                pcReset<=0;
                Extop<=0;
                AluSrc<=1;//EXT
                BranchType<=3'b000;
                Aluop<=5'b10100;
                Jump<=0;
                MemtoReg<=1;
            end        
        endcase         
 
    end
    
    //data forwarding
    //在ALU的输入段加入俩个选择器，输入分别为正常的数据流输入，EX段前送的数据，MEM段前送的数据
    //rs1
    always@(*)begin
        if(Instruction[19:15]==EX_rd&&RegWrite_EX==1&&EX_rd!=0)//EX_rd!=0表示 0号寄存器恒为零，应在RegFile中设置判断
            s1<=2'b00; //EX段数据冲突，选择EX_AluResult向前送
        else if(Instruction[19:15]==MEM_rd&&RegWrite_MEM==1&&MEM_rd!=0)
            s1<=2'b01;//MEM段数据冲突，选择MEM_MemtoRegMuxOut向前送(MemtoMuxOut 是Mem段要写寄存器的结果)
        else s1<=2'b10;//默认没有冲突

    end
    //rs2
    always@(*)begin

        if(Instruction[24:20]==EX_rd&&RegWrite_EX==1&&EX_rd!=0)//EX 冒险和MEM冒险同时发生 EX具有优先性 ，因为EX会覆盖掉MEM冒险上同
            s3<=2'b00;
        else if(Instruction[24:20]==MEM_rd&RegWrite_MEM==1&&MEM_rd!=0)
            s3<=2'b01;
        else s3<=2'b10;
    end

    
    //lw 单独处理，因为这是距离为3的冲突，而前推只能处理距离<=2的冲突。
    //lw在单独处理暂停一个周期后，还是会有两个周期的差距，这是可检测为EX段的冲突
    always@(*)begin

      //rs1
      //判断冲突的条件，即lw在EX段要写入的寄存器和本指令（lw的下一条）要读取的寄存器冲突，当然要检测上一条是否是lw指令，因为memread=1的指令只有lw指令
        if(Instruction[19:15]==EX_rd&&EX_MemRead==1)begin
            lw_stall<=1;//PC,IF暂停一个周期
            clear<=0; //感觉应该ID_EX清空，否则会错误多写入一个寄存器，仿真可看到；但并不影响数据正确性和时序
         end
         else begin
            lw_stall<=0;
            clear<=0;            
         end                 
    //end
    
    //rs2
        if(Instruction[24:20]==EX_rd&&EX_MemRead==1)begin
            lw_stall<=1;
            clear<=0;       
        end
        else begin
            lw_stall<=0;
            clear<=0;               
         end
    end

endmodule
