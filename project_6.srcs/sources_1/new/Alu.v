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
    input[4:0] Aluop,//�����
    input[31:0] AluX,
    input[31:0] AluY,
    output reg ZF,CF,OF,//�㡢��λ�����
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
                //���������ͬ�ţ�����ӽ����֮��ţ�OF=1
                if(AluX[31]==1'b0&AluY[31]==1'b0&Result[31]==1'b1)
                    OF<=1;
                else if(AluX[31]==1'b1&AluY[31]==1'b1&Result[31]==1'b0)
                    OF<=1;
                else OF<=0;
            end
            5'b00010:begin //sub
                Result<=$signed(AluX)-$signed(AluY);
                //�����������ţ��������뱻���������෴��OF<=1
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
                if(Result==0)
                    ZF<=1;
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
                if(!Result)begin
                    ZF<=0;
                end
            end
            5'b01101:begin
                Result<=($signed(AluX)<$signed(AluY))?1:0;
                 if(!Result)begin
                    ZF<=0;
                end
            end
            5'b10000:begin // mul
                Result<=$signed(AluX) * $signed(AluY);
            end
            5'b10001:begin // div
                if (AluY != 0) begin
                    Result <= $signed(AluX) / $signed(AluY);
                end else begin
                    Result <= 32'h80000000;//���ڴ�������趨һ���ض�ֵ
                end
            end
             5'b10010: begin // mulh
                    Result <= ($signed(AluX) * $signed(AluY)) >> 32; // ����ֻ����˷��ĸ�λ�����������
            end
             5'b10011: begin // divu
                    if (AluY != 0) begin
                        Result <= $unsigned(AluX) / $unsigned(AluY);
                    end 
                    else begin
                        Result <= 32'h80000000; // ���ڴ�������趨һ���ض�ֵ
                    end
             end
             5'b10100:begin//LUI
                Result<=AluY<<4'b1100;
             end
        endcase
    end       
            
endmodule
