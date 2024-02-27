`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 16:49:22
// Design Name: 
// Module Name: PC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//pc_hold Ϊ����һ��ʱ�ӵ��źţ���Ҫ����lwָ�����ͣ���ڣ�����⵽���ݳ�ͻʱlwָ������ģ�ConUnit�ᷢ��stall�źţ�����������һ��ʱ�����ڵ�PC����ȡԭ����ֵ
//InPCΪ��һ���ڵ�PCֵ������������⣨��ͣһ�����ں������-4��PC����һ��ֵ����InPC����
//����PCֵ�����ĸ��Ĵ�����
    //1InsAddr:��Ҫ�����PC����һ��ָ��ĵ�ַ
    //2cur_pc����ǰ��pc������ʵ״̬���InsAddr��ȣ��ɿ���ΪInsAddr�ı���
    //3hold_pc����һ�ε�PC�����ڼ���pre_pc
    //4pre_pc�����ϴε�PC
// Ϊʲô��Ҫ��ô��PC��
//��Ҫ��lwָ����Ҫ��ͣһ�����ڣ�����Ϊ���¸�����ʹ���뱾������ͬ��PC.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clk,
    input pc_hold,//����PC����һ��ʱ��
    input[31:0] InPC,
    output reg[31:0] InsAddr
    );
    reg[31:0] cur_pc;//���浱ǰ��PC
    reg[31:0] hold_pc;//������һ�ε�PC
    reg[31:0] pre_pc;//�������ϴ�PC
    always@(cur_pc)begin
        InsAddr<=cur_pc;
    end
    initial begin
        InsAddr<=-4;
        hold_pc<=-4;
        pre_pc<=-8;
    end
     //Ӧ����pc_hold���pcά��

    always@(posedge clk or posedge pc_hold)begin
            if(pc_hold)begin
               cur_pc<=pre_pc;
               pre_pc<=hold_pc;
               hold_pc<=pre_pc;
            end
            else if(InsAddr==-4)begin//��һ��ȡָ����ΪPC��ʼ����-4��Ҳͬ����Ϊ��һ������InPCΪ���裬��ΪΪ����Ҫ�ȵ�IF�׶���ɺ����PC+4������ֵ������PCsrcMux
                cur_pc<=InsAddr+4;
                pre_pc<=hold_pc;
                hold_pc<=InsAddr+4;
            end
            else begin 
                 cur_pc<=InPC;
                 pre_pc<=hold_pc;
                 hold_pc<=InPC;     
            end
    end    


    
endmodule
