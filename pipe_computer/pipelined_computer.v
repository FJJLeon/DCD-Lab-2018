/*
module  pipelined_computer ( resetn,clock,mem_clock, 
									  pc,inst,ealu,malu,walu,
									  sw, key, hex5, hex4, hex3, hex2, hex1, hex0, led );
*/
module  pipelined_computer ( resetn,clock,mem_clock, 
									  pc,inst,ealu,malu,walu,
									  swleft5, swright5, key3, key2, key1, data0, data1, data2, led);	

//定义顶层模块 pipelined_computer

/*
	// 定义计算机的 I/O 端口。
	input  [9:0]  sw;
	input  [3:1]  key;
	output [6:0]  hex5, hex4, hex3, hex2, hex1, hex0;
	output [9:0]  led;
*/

	// 定义计算机的 I/O 端口。
	//input  [9:0]  sw;
	input  [4:0] swleft5, swright5;
	input         key3, key2, key1;
	output [31:0] data0, data1, data2;
	output [9:0]  led;

	//定义整个计算机 module 和外界交互的输入信号，包括复位信号 resetn、时钟信号 clock、 以及一个和 clock 同频率但反相的 mem_clock 信号
	//mem_clock 用于指令同步 ROM 和 数据同步 RAM 使用，其波形需要有别于实验一。 
	//这些信号可以用作仿真验证时的输出观察信号。 
	input          resetn, clock, mem_clock; 

	//模块用于仿真输出的观察信号。缺省为 wire 型。
	output  [31:0]  pc,inst,ealu,malu,walu; 
	
	// 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。IF 取指令阶段。
	wire   [31:0]  pc, bpc, jpc, npc, pc4, ins, inst;  
	
	// 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。ID 指令译码阶段。
	wire   [31:0]  dpc4, da, db, dimm; // dim指导书可能写错，与后文接口变量名不同
	
	// 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。EXE 指令运算阶段。
	wire   [31:0]  epc4, ea, eb,eimm;  
	
	// 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。MEM 访问数据阶段。
	wire   [31:0]  mb,mmo; 

	// 模块间互联传递数据或控制信息的信号线，均为 32 位宽信号。WB 回写寄存器阶段。
	wire   [31:0]  wmo,wdi; 
	
	// 模块间互联，通过流水线寄存器传递结果寄存器号的信号线，寄存器号（32 个）为 5bit。
	// 结果寄存器号
	wire   [4:0]   drn,ern0,ern,mrn,wrn; 

	// ID 阶段向 EXE 阶段通过流水线寄存器传递的 aluc 控制信号，4bit。
	wire   [3:0]   daluc,ealuc; 

	// CU 模块向 IF 阶段模块传递的 PC 选择信号，2bit。
	// 00:pc4   
	// 01:bpc
	// 10:da
	// 11:jpc,  j addr
	wire   [1:0]   pcsource; 

	// CU 模块发出的控制流水线停顿的控制信号，使 PC 和 IF/ID 流水线寄存器保持不变。
	// write pc in ir: unset for stall in F_reg D_reg
	wire           wpcir; 

	// ID 阶段产生，需往后续流水级传播的控制信号。
	wire          dwreg,dm2reg,dwmem,daluimm,dshift,djal;  

	// 来自于 ID/EXE 流水线寄存器，EXE 阶段使用，或需要往后续流水级传播的控制信号。
	wire          ewreg,em2reg,ewmem,ealuimm,eshift,ejal;  

	// 来自于 EXE/MEM 流水线寄存器，MEM 阶段使用，或需要往后续流水级传播的控制信号。
	wire          mwreg,mm2reg,mwmem;  

	// 来自于 MEM/WB 流水线寄存器，WB 阶段使用的控制信号
	wire          wwreg,wm2reg;          

	// 程序计数器模块，是最前面一级 IF 流水段的输入。
	// F reg
	pipepc_F_reg  prog_cnt ( npc,wpcir,clock,resetn,pc ); 

// IF
	// IF 取指令模块，注意其中包含的指令同步 ROM 存储器的同步信号。
	// 留给信号半个节拍的传输时间。
	pipeif_F_stage  IF_stage   ( pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock );  //  IF stage 

	// IF/ID 流水线寄存器模块，起承接 IF 阶段和 ID 阶段的流水任务。
	// 在 clock 上升沿时，将 IF 阶段需传递给 ID 阶段的信息，锁存在 IF/ID 流水线寄存器中，并呈现在 ID 阶段。
	pipeir_D_reg  inst_reg   ( pc4,ins,wpcir,clock,resetn,dpc4,inst );        // IF/ID  

// ID
	// ID 指令译码模块。注意其中包含控制器 CU、寄存器堆及多个多路器等。
	// 其中的寄存器堆，会在系统 clock 的下沿进行寄存器写入，也就是给信号从 WB 阶段
	// 传输过来留有半个 clock 的延迟时间，亦即确保信号稳定。
	// 该阶段 CU 产生的，要传播到流水线后级的信号较多。
	pipeid_D_stage  ID_stage  ( mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,                      
								wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,                      
								bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,                      
								daluimm,da,db,dimm,drn,dshift,djal );        //  ID stage

	// ID/EXE 流水线寄存器模块，起承接 ID 阶段和 EXE 阶段的流水任务。
	// 在 clock 上升沿时，将 ID 阶段需传递给 EXE 阶段的信息，锁存在 ID/EXE 流水线寄存器中，并呈现在 EXE 阶段。
	pipedereg_E_reg  de_reg  ( dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,                       
								djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm,                       
								ea,eb,eimm,ern0,eshift,ejal,epc4 );          // ID/EXE 娴佹按绾垮瘎瀛樺櫒 

// EXE
	// EXE 运算模块。其中包含 ALU 及多个多路器等。
	pipeexe_E_stage  EXE_stage ( ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu );  // EXE stage 
				
	//EXE/MEM流水线寄存器模块，起承接 EXE 阶段和 MEM 阶段的流水任务。 
	//在 clock 上升沿时，将 EXE 阶段需传递给 MEM 阶段的信息，锁存在 EXE/MEM 
	//流水线寄存器中，并呈现在 MEM 阶段。 
	pipeemreg_M_reg  em_reg  ( ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn,                        
								mwreg,mm2reg,mwmem,malu,mb,mrn); // EXE/MEM流水线寄存器 
 
 // MEM
	//MEM 数据存取模块。其中包含对数据同步 RAM 的读写访问。// 注意 mem_clock。 
	//输入给该同步 RAM 的 mem_clock 信号，模块内定义为 ram_clk。 
	//实验中可采用系统 clock 的反相信号作为 mem_clock 信号（亦即 ram_clk）, 
	//即留给信号半个节拍的传输时间，然后在 mem_clock 上沿时，读输出、或写输入。 	
/*
	pipemem_M_stage  MEM_stage ( mwmem, malu, mb, mem_clock, resetn, mmo,
								sw, key, hex5, hex4, hex3, hex2, hex1, hex0, led);        //  MEM stage 
*/
	pipemem_M_stage2 MEM_stage(mwmem, malu, mb, mem_clock, resetn, mmo, 
								swleft5, swright5, key3, key2, key1, data0, data1, data2, led);

	
	//MEM/WB 流水线寄存器模块，起承接 MEM 阶段和 WB 阶段的流水任务。 
	//在 clock 上升沿时，将 MEM 阶段需传递给 WB 阶段的信息，锁存在 MEM/WB 
	//流水线寄存器中，并呈现在 WB 阶段。 
	pipemwreg_W_reg  mw_reg  ( mwreg,mm2reg,mmo,malu,mrn,clock,resetn,                            
								wwreg,wm2reg,wmo,walu,wrn);     //  MEM/WB 流水线寄存器 
	
// WB
	//WB 写回阶段模块。事实上，从设计原理图上可以看出，该阶段的逻辑功能部件只 
	//包含一个多路器，所以可以仅用一个多路器的实例即可实现该部分。 
	//当然，如果专门写一个完整的模块也是很好的。 
	mux2x32  WB_stage  ( walu,wmo,wm2reg,wdi );          //  WB stage 

endmodule









