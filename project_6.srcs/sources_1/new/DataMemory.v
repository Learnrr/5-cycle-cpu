`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/18 17:04:23
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,
    input we,
    input re,
    input sign,//load,store byte/half 有无符号
    input[3:0] Mem_sel,//byte/word/half
    input[31:0] Addr,
    input[31:0] InData,
    output reg[31:0] OutData
    );
    reg[7:0] DataMem[255:0];
    integer i;
    
    initial begin //初始化，随便写的
        for(i=0;i<100;i=i+1)
            DataMem[i]=i;
    end
    
    always@(posedge clk)begin
        if(we)begin 
            if(Mem_sel==4'b1111)begin
                DataMem[Addr]<=InData[31:24]; //按字节写入
                DataMem[Addr+1]<=InData[23:16];
                DataMem[Addr+2]<=InData[15:8];
                DataMem[Addr+3]<=InData[7:0]; 
            end
            else if(Mem_sel==4'b0011)begin
                DataMem[Addr]<={8{InData[15]}}; 
                DataMem[Addr+1]<={8{InData[15]}};
                DataMem[Addr+2]<=InData[15:8];
                DataMem[Addr+3]<=InData[7:0]; 
            end
            else if(Mem_sel==4'b0001)begin
                DataMem[Addr]<={8{InData[7]}}; 
                DataMem[Addr+1]<={8{InData[7]}};
                DataMem[Addr+2]<={8{InData[7]}};
                DataMem[Addr+3]<=InData[7:0]; 
            end
        end
    end    

    always@(negedge clk)begin
        if(re) begin
            
            if(Mem_sel==4'b1111)begin
                OutData[7:0]<= DataMem[Addr+3];//按字节读取
                OutData[15:8]<= DataMem[Addr+2];
                OutData[23:16]<= DataMem[Addr+1];
                OutData[31:24]<= DataMem[Addr];
            end
            else if(Mem_sel==4'b0011)begin
                OutData[7:0]<= DataMem[Addr+3];
                OutData[15:8]<= DataMem[Addr+2];
                if(sign)begin
                    OutData[23:16]<= DataMem[Addr+2][7];
                    OutData[31:24]<= DataMem[Addr+2][7];
                end
                else begin
                    OutData[23:16]<=0;
                    OutData[31:24]<=0;
                end
            end
            else if(Mem_sel==4'b0001)begin
                OutData[7:0]<= DataMem[Addr+3];
                if(sign)begin
                    OutData[15:8]<= DataMem[Addr+3][7];
                    OutData[23:16]<= DataMem[Addr+3][7];
                    OutData[31:24]<= DataMem[Addr+3][7];
                end
                else begin
                    OutData[15:8]<= 0;
                    OutData[23:16]<= 0;
                    OutData[31:24]<=0;
                end
            end
        end
    end

endmodule
