`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 22:51:11
// Design Name: 
// Module Name: dff_32
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

module dff(
    input clk,
    input d,
    output reg q
    );
always@(posedge clk)begin
    q<=d;
end
endmodule
module dff_3(
    input clk,
    input[2:0] d,
    output reg[2:0] q
);    
always@(posedge clk)begin
    q<=d;
end
endmodule
module dff_4(
    input clk,
    input[3:0] d,
    output reg[3:0] q
);    
always@(posedge clk)begin
    q<=d;
end
endmodule
module dff_5(
    input clk,
    input[4:0] d,
    output reg[4:0] q
);    
always@(posedge clk)begin
    q<=d;
end
endmodule
module dff_32(
    input clk,
    input[31:0] d,
    output reg[31:0] q
);    
always@(posedge clk)begin
    q<=d;
end
endmodule


