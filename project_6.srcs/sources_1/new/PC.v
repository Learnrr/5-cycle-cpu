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
//pc_hold 为锁存一个时钟的信号，主要用于lw指令的暂停周期，当检测到数据冲突时lw指令引起的，ConUnit会发出stall信号，传过来让下一个时钟周期的PC继续取原来的值
//InPC为下一周期的PC值，除特殊情况外（暂停一个周期和起初的-4）PC的下一个值都是InPC给的
//保存PC值得有四个寄存器：
    //1InsAddr:需要输出得PC，下一条指令的地址
    //2cur_pc：当前的pc，除其实状态外和InsAddr相等，可看作为InsAddr的备份
    //3hold_pc：上一次的PC，用于计算pre_pc
    //4pre_pc：上上次的PC
// 为什么需要这么多PC？
//主要是lw指令需要暂停一个周期，表现为在下个周期使用与本周期相同的PC.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input clk,
    input pc_hold,//控制PC锁存一个时钟
    input[31:0] InPC,
    output reg[31:0] InsAddr
    );
    reg[31:0] cur_pc;//保存当前的PC
    reg[31:0] hold_pc;//保存上一次的PC
    reg[31:0] pre_pc;//保存上上次PC
    always@(cur_pc)begin
        InsAddr<=cur_pc;
    end
    initial begin
        InsAddr<=-4;
        hold_pc<=-4;
        pre_pc<=-8;
    end
     //应根据pc_hold完成pc维持

    always@(posedge clk or posedge pc_hold)begin
            if(pc_hold)begin
               cur_pc<=pre_pc;
               pre_pc<=hold_pc;
               hold_pc<=pre_pc;
            end
            else if(InsAddr==-4)begin//第一次取指，因为PC初始赋成-4，也同样因为第一次输入InPC为高阻，因为为至少要等到IF阶段完成后产生PC+4才能有值：来自PCsrcMux
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
