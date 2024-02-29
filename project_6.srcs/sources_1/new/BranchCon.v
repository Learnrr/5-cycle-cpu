`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/24 15:17:00
// Design Name: 
// Module Name: BranchCon
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


module BranchCon(
    input[2:0] BranchType,
    input[31:0] AluResult,
    input ZF,
    output reg branchE
    );
    always@(*)begin
        case(BranchType)
            3'b000:begin branchE<=0;end
            3'b001:begin branchE<= (ZF==1)?1:0;end
            3'b010:begin branchE<= (ZF==1)?0:1;end
            3'b011:begin branchE<=AluResult==1?1:0;end
            3'b100:begin branchE<=AluResult==1?0:1;end
            3'b101:begin branchE<=AluResult==1?1:0;end
            3'b110:begin branchE<=AluResult==1?0:1;end
        endcase
    end
endmodule
