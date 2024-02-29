将单周期改为经典五周期cpu
起初为每条指令的五个周期线性执行
若流水化处理可将 C.v中
 PC PC(
        .clk(clk),.InPC(MEM_WB_jumpAddr_out),.InsAddr(InsAddr)
    );
 InPC由MEM_WB_jumpAddr_out改为pcadd4

 无法解决数据冒险和控制冒险
