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
    input[31:0] Instruction,
    
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
    

    // 判断是否使用了regB
    input[4:0] EX_rd, // 执行段要写的寄存器
    input[4:0] MEM_rd,//访存段要写的寄存器
    output reg[1:0]  s1,s2,s3,s4
    );
    reg[6:0] opcode;
    reg[2:0] funct3;
    reg[6:0] funct7;
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
                
                Mem_sel<=4'b1111;//32位
                case(funct3)
                    3'b000:begin Aluop<=5'b00001;end//addi
                    3'b100:begin Aluop<=5'b00111;end//xori
                    3'b110:begin Aluop<=5'b00110;end//ori
                    3'b111:begin Aluop<=5'b00101;end//andi
                    3'b001:begin Aluop<=5'b01000;end//slli ////////////////////////////////unfinished
                    3'b101:begin                    
                        if(Instruction[31:25]==7'b0000000)begin//srli /////////////////////unfinished
                            Aluop<=5'b01001;
                        end
                        else begin
                            Aluop<=5'b01011;//srai ///////////////////////////unfinished
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
                case(funct3)
                    3'b000:begin Aluop<=5'b00010;BranchType<=3'b001;end//beq
                    3'b001:begin Aluop<=5'b00010;BranchType<=3'b010;end//bne
                    3'b100:begin Aluop<=5'b01101;BranchType<=3'b011;end//blt
                    3'b101:begin Aluop<=5'b01101;BranchType<=3'b100;end//bge
                    3'b110:begin Aluop<=5'b01100;BranchType<=3'b101;end//bltu
                    3'b111:begin Aluop<=5'b01100;BranchType<=3'b110;end//bgeu
                endcase
            end
            7'b1101111:begin//J
                Jump<=1;
            end        
        endcase             
    end
    //data forwarding
    //rs1
    always@(*)begin
        if(Instruction[19:15]==EX_rd)
            s1<=2'b00;
         if(Instruction[19:15]==MEM_rd)
            s1<=2'b01;
          else s1<=2'b10;
    end
    //rs2
    always@(*)begin
        if(Instruction[24:20]==EX_rd)
            s3<=2'b00;
        if(Instruction[24:20]==MEM_rd)
            s3<=2'b01;
         else s3<=2'b10;
    end
    
endmodule
