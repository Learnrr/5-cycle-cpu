`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 21:40:57
// Design Name: 
// Module Name: MAIN
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

module MAIN(
    input clk,
    input rst,
    output [6:0] LEDL,LEDL1,
    output [7:0] sel
    );
    wire[31:0] LED_CON_result;
    wire[31:0] Instruction;
    reg nclk;
    reg[29:0] cnt;
    parameter maxcnt=20000000;
    initial begin
        nclk<=0;
        cnt<=0;
    end
    
    always@(posedge clk or negedge rst)begin
		if(!rst)
			cnt <= 30'd0;
		else if(cnt == maxcnt)begin
			nclk <= ~nclk;
			cnt<=0;
	   end
		else
			cnt<=cnt+1'b1;
    end
   
//    TOP TOP(
//        .clk(nclk),.rst(rst),.LED_CON_result(LED_CON_result)
//    );  
  Cpu Cpu(.clk(nclk),.rst(rst),.AluResult(AluResult),.Instruction(Instruction),.RegOutB(RegOutB),.MemDataOut(MemDataOut)
    );
    
    hex8 hex8(
        .clk(clk),.rst_n(rst),.data(Instruction),.seg(LEDL),.sel(sel),.seg1(LEDL1)
    );
endmodule
