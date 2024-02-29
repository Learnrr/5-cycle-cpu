`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 19:56:14
// Design Name: 
// Module Name: Alu
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

// add,sub,addu,subu,or,xor,<<,<<<,>>,>>>,
module Alu(
    input[4:0] Aluop,
    input[31:0] AluX,
    input[31:0] AluY,
    output reg ZF,CF,OF,
    output reg[31:0] Result
    );
    
    initial begin
    ZF<=0;
    CF<=0;
    OF<=0; 
    end
    
    always@(*)begin
        case(Aluop)
            5'b00001:begin //add
                Result<=$signed(AluX)+$signed(AluY);
                //如果两个数同号，而相加结果与之异号，OF=1
                if(AluX[31]==1'b0&AluY[31]==1'b0&Result[31]==1'b1)
                    OF<=1;
                else if(AluX[31]==1'b1&AluY[31]==1'b1&Result[31]==1'b0)
                    OF<=1;
                else OF<=0;
            end
            5'b00010:begin //sub
                Result<=$signed(AluX)-$signed(AluY);
                //如果两个数异号，相减结果与被减数符号相反，OF<=1
                if(AluX[31]==1'b1&AluY[31]==1'b0&Result[31]==1'b0)
                    OF<=1;
                else if(AluX[31]==1'b0&AluY[31]==1'b1&Result[31]==1'b1)
                    OF<=1;
                else OF<=0;
               
                if(Result==0) ZF<=1;
                else ZF<=0;
            end
            5'b00011:begin //addu
                Result<=$unsigned(AluX)+$unsigned(AluY);
                if(Result<AluX&Result<AluY)
                    CF<=1;
                else CF<=0;
            end
            5'b00100:begin //subu
                Result<=$unsigned(AluX)-$unsigned(AluY);
                if(AluX<AluY)
                    CF<=1;
                else CF<=0;
                if(Result==0)ZF<=1;
                else ZF<=0;
            end
            5'b00101:begin //and 
                Result<=AluX&AluY;
            end
            5'b00110:begin //or
                Result<=AluX|AluY;
            end
            5'b00111:begin //xor 
                Result<=AluX^AluY;
                if(Result==0)ZF<=1;
            end
            5'b01000:begin //<<
                Result<=AluX<<AluY;
            end
            5'b01001:begin  //>>
                Result<=AluX>>AluY;
            end
            5'b01010:begin //<<< 
                Result<=AluX<<<AluY;
            end
            5'b01011:begin //>>>
                Result<=AluX>>>AluY;
            end
            5'b01100:begin
                Result<=(AluX<AluY)?1:0;
            end
            5'b01101:begin
                Result<=($signed(AluX)<$signed(AluY))?1:0;
            end
        endcase
    end       
            
endmodule
