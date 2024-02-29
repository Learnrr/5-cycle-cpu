`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/24 21:25:04
// Design Name: 
// Module Name: PCadd4
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


module PCadd4(
    input[31:0] pc,
    output[31:0] pcadd4
    );
    assign pcadd4 = pc+4;
    
endmodule
