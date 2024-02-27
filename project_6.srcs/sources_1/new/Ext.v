`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 19:12:06
// Design Name: 
// Module Name: Ext
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


module Ext(
    input sign,
    input[31:0] Instruction,
    output reg[31:0] Imm
    );
    reg[6:0] opcode;
    reg[2:0]funct3;
    reg[11:0]IMM;
    
    always@(*)begin
     opcode<=Instruction[6:0];
     funct3<=Instruction[14:12];
     IMM<=Instruction[31:20];
        //I-type
        if(opcode==7'b0010011|opcode==7'b0000011|opcode==7'b1110011|opcode==7'b1100111)begin
            if(funct3==3'b001|funct3==3'b101)begin//;slli,srli,srai
                if(sign)
                    Imm<={{27{IMM[11]}},IMM[4:0]};
                else
                    Imm<={{27{1'b0}},IMM[4:0]};
            end
            else begin          
                if(sign)
                    Imm<={{20{Instruction[31]}},Instruction[31:20]};
                else 
                    Imm<={{20{1'b0}},Instruction[31:20]};
            end
        end
        //S-type
        else if(opcode==7'b0100011)begin
            if(sign)
                Imm<={{20{Instruction[31]}},Instruction[31:25],Instruction[11:7]};
            else
                Imm<={{20{1'b0}},Instruction[31:25],Instruction[11:7]};
        end
        //B-type
        else if(opcode==7'b1100011)begin
            if(sign)
                Imm<={{19{Instruction[31]}},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
            else
                Imm<={{19{1'b0}},Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
        end
        //U-type
        else if(opcode==7'b0110111|opcode==7'b0010111)begin
                Imm<={Instruction[31:12],{12{1'b0}}};
        end
        //J-type
        else if(opcode==7'b1101111)begin
            if(sign)
                Imm<={{12{Instruction[31]}},Instruction[31],Instruction[19:12],Instruction[20],Instruction[30:21]};
            else
                Imm<={{12{1'b0}},Instruction[31],Instruction[19:12],Instruction[20],Instruction[30:21]};
        end
    end
endmodule
