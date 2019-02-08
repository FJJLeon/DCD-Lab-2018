// pipe IF stage
// IF 取指令模块，注意其中包含的指令同步 ROM 存储器的同步信号。
module pipeif_F_stage( 
				pcsource, 
				pc, bpc, da, jpc, npc, pc4,
				ins, mem_clock );

	input 		 mem_clock;
	input [1:0]  pcsource;
	input [31:0] pc,bpc,da,jpc;
	
	output [31:0] npc,pc4,ins;

	assign pc4 = pc + 4;
	
	mux4x32 selectNextpc (pc4, bpc, da, jpc, pcsource, npc);
	lpm_rom_irom instmem (pc[8:2],mem_clock,ins);// instruction memory. // why not same , gsy for 8:2, others 7:2
	
endmodule