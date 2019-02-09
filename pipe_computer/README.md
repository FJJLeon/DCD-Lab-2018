## 5段流水线CPU
* 实现基本的具有 20 条MIPS指令的 5 段流水线 CPU
* 实现 **Forwarding** 和 **Stall**

### 关键文件
控制单元CU需要更多的控制信号，为每个流水阶段(FDEMW)编写执行模块和流水线寄存器模块
* [`pipe_cu.v`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipe_cu.v): 添加控制信号处理 **Forwarding** 和 **Stall**
* IF阶段: [`IF取指模块`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipeif.v) 、[`IF/ID 流水线寄存器`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipeir.v) 
* ID阶段: [`ID译码模块`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipeid.v)、[`ID/EXE 流水线寄存器`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipedereg.v)
* EXE阶段: [`EXE运算模块`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipeexe.v)、[`EXE/MEM 流水线寄存器`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipeemreg.v)
* MEM阶段: [`MEM存取阶段`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipemem_M_stage2.v)、[`MEM/WB 流水线寄存器`](https://github.com/FJJLeon/DCD-LAB-2018/blob/master/pipe_computer/pipemwreg.v)
* WB阶段: `WB写回阶段`仅需要一个MUX即可

### Reference
* [Wesley-Jzy/SJTU-DCD-LAB-2017](https://github.com/Wesley-Jzy/SJTU-DCD-LAB-2017)