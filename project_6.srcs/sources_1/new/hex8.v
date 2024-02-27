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


module hex8(//����ʱ���źź�Ҫ��ʾ��ֵ����ʽΪ8��ʮ������
	input clk,
	input rst_n,
	input [31:0] data,
	output reg [6:0] seg=0,seg1=0,//��ʾ����
	output [7:0] sel
);
	reg [18:0] cnt_d; //���ơ�λ���Ʒ�Ƶ50000
	reg 	  clk_1k;//λ�ƿ���ʱ���ź�
	reg [3:0]  data_reg;
	parameter maxcnt =50000;
	reg[3:0] disp_bit=0;//���� ��չʾ��λ�� ����ѭ��������clk_lk��һ������Ҳ����50000��clk�����ƶ�һλ��
	//������50000��ʱ�����ڣ����������ɲ�׽������λ��ʾ�ı仯��������Ϊ��8�������ͬʱ��ʾ
	reg[7:0] sel_reg;//����8λ�����չʾ��λ��
	initial begin
	   sel_reg<=8'b0000_0001;
	   cnt_d<=0;
	   clk_1k<=0;
	   data_reg<=4'b0000;
	   end
//----div----------------------------------
	
	always@(posedge clk )begin//ÿ��ʱ���ص���ʱcnt_d��һ��ÿ��50000ʱ��ʹclk_lk��һ��������Ƶ��ƵΪ50000000��
	//����֪��һ������������ʾ������ܱ任10000�Σ������Ƶ50000000��ʾ������ͣ��1s��������1s�У��˸�����ܻ᲻��ѭ��10000�Σ�
	//�����Ӿ�������ʹ��8����ܿ�����ͬʱ����
		
		if(cnt_d == maxcnt)begin
			clk_1k <= ~clk_1k;
			cnt_d<=0;
	   end
		else
			cnt_d<=cnt_d+1'b1;
    end

	always@(posedge clk_1k)begin //������ʾ����һλ����ܲ��ϱ任��ͬʱ����ʱ����ʾ����λ����ܸ�Ӧ����ʾ����ֵ������˵Ӧ����ʾ����12345678������ѭ�������λ�����԰�data_reg��ֵΪ1
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
		always@(*)begin//������Ҫ��ʾ����һλ�����ݣ����ƶ�Ӧλ����ܵ����𣬼���ʮ���������ݷ�ӳ����״Ϊ8��������ϡ�
		  if(sel_reg>8'b00001000)begin//��������ư�λ�����������Ҫ������ͬ���źţ�ÿһ��������λ����ܣ�
		  //����Ǹ���λ����ʾ���͸��������λ�ļĴ���������
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
		 //����ǵ���λ��Ҫ��ʾ����ô�͸��������λ�����ݼĴ�����ֵ
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
