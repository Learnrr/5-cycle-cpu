`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 21:35:32
// Design Name: 
// Module Name: hex8
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


module hex8(//传入时钟信号和要显示的值，格式为8个十六进制
	input clk,
	input rst_n,
	input [31:0] data,
	output reg [6:0] seg=0,seg1=0,//显示的数
	output [7:0] sel
);
	reg [18:0] cnt_d; //控制“位”移分频50000
	reg 	  clk_1k;//位移控制时钟信号
	reg [3:0]  data_reg;
	parameter maxcnt =50000;
	reg[3:0] disp_bit=0;//控制 所展示的位数 不断循环，会在clk_lk的一个周期也就是50000个clk周期移动一位，
	//尽管是50000个时钟周期，但肉眼依旧捕捉不到换位显示的变化，可以认为是8个译码管同时显示
	reg[7:0] sel_reg;//控制8位数码管展示的位数
	initial begin
	   sel_reg<=8'b0000_0001;
	   cnt_d<=0;
	   clk_1k<=0;
	   data_reg<=4'b0000;
	   end
//----div----------------------------------
	
	always@(posedge clk )begin//每次时钟沿到来时cnt_d加一，每到50000时会使clk_lk加一，根据主频分频为50000000，
	//可以知道一个大周期内显示的数码管变换10000次，加入分频50000000显示的数据停留1s，则在这1s中，八个数码管会不断循环10000次，
	//人眼视觉暂留会使得8数码管看起来同时亮灭。
		
		if(cnt_d == maxcnt)begin
			clk_1k <= ~clk_1k;
			cnt_d<=0;
	   end
		else
			cnt_d<=cnt_d+1'b1;
    end

	always@(posedge clk_1k)begin //控制显示的那一位数码管不断变换，同时给当时所显示的那位数码管赋应该显示的数值，比如说应该显示数据12345678，正好循环到最高位，所以把data_reg赋值为1
        case(disp_bit)
            4'b0000:begin
                sel_reg<=8'b00000001;
                data_reg<=data[3:0];disp_bit<=disp_bit+1'b1;end
             4'b0001:begin
                sel_reg<=8'b00000010;
                data_reg<=data[7:4];disp_bit<=disp_bit+1'b1;end
            4'b0010:begin
                sel_reg<=8'b00000100;
                data_reg<=data[11:8];disp_bit<=disp_bit+1'b1;end
                
            4'b0011:begin
                sel_reg<=8'b00001000;
                data_reg<=data[15:12];disp_bit<=disp_bit+1'b1;end
             4'b0100:begin
                sel_reg<=8'b00010000;
                data_reg<=data[19:16];disp_bit<=disp_bit+1'b1;end    
              4'b0101:begin
                sel_reg<=8'b00100000;
                data_reg<=data[23:20];disp_bit<=disp_bit+1'b1;end   
             4'b0110:begin
                sel_reg<=8'b01000000;
                data_reg<=data[27:24];disp_bit<=disp_bit+1'b1;end
             4'b0111:begin
                sel_reg<=8'b10000000;
                data_reg<=data[31:28];disp_bit<=disp_bit+1'b1;end
            4'b1000:begin
                sel_reg<=8'b00000000;
                data_reg<=0;disp_bit<=0;
                end
         endcase
	end

//----LUT-----------------------------------
		always@(*)begin//根据需要显示的那一位的数据，控制对应位数码管的亮灭，即把十六进制数据反映到形状为8的数码管上。
		  if(sel_reg>8'b00001000)begin//开发板控制八位数码管亮灭需要两个不同的信号，每一个控制四位数码管，
		  //如果是高四位的显示，就给负责高四位的寄存器赋数据
			case(data_reg)		
				4'b0000: seg <=  7'b111_1110;//////
				4'b0001: seg <=  7'b011_0000;
				4'b0010: seg <=  7'b100_1101;
				4'b0011: seg <=  7'b111_1001;
				4'b0100: seg <=  7'b011_0011;
				4'b0101: seg <=  7'b101_1011;
				4'b0110: seg <=  7'b101_1111;
				4'b0111: seg <=  7'b111_0000;
				4'b1000: seg <=  7'b111_1111;
				4'b1001: seg <=  7'b111_1011;
				4'b1010: seg <= 7'b111_0111;
				4'b1011: seg <= 7'b001_1111;
				4'b1100: seg <= 7'b100_1110;
				4'b1101: seg <= 7'b011_1101;
				4'b1110: seg <= 7'b100_1111;
				4'b1111: seg <= 7'b100_0111;
		//		default: seg <= 000_0000;
		     endcase	
		  
		 end
		 //如果是第四位的要显示，那么就给负责低四位的数据寄存器赋值
		  else begin//
		      	case(data_reg)		
				4'd0: seg1 <=  7'b111_1110;//////
				4'd1: seg1<=  7'b011_0000;
				4'd2: seg1 <=  7'b100_1101;
				4'd3: seg1 <=  7'b111_1001;
				4'd4: seg1 <=  7'b011_0011;
				4'd5: seg1 <=  7'b101_1011;
				4'd6: seg1 <=  7'b101_1111;
				4'd7: seg1 <=  7'b111_0000;
				4'd8: seg1 <=  7'b111_1111;
				4'd9: seg1 <=  7'b111_1011;
				4'd10: seg1 <= 7'b111_0111;
				4'd11: seg1 <= 7'b001_1111;
				4'd12: seg1 <= 7'b100_1110;
				4'd13: seg1 <= 7'b011_1101;
				4'd14: seg1 <= 7'b100_1111;
				4'd15: seg1 <= 7'b100_0111;
		//		default: seg <= 000_0000;
		     endcase	
		  end
		end
//----MUX2-1---------------------------------
	assign sel=sel_reg;
endmodule
