// pipe IF input
// 程序计数器模块，是最前面一级 IF 流水段的输入。
module pipepc_F_reg( npc, wpcir, clock, resetn, pc);
	
   input  [31:0] npc;
   input  		  wpcir,clock,resetn;
	
   output [31:0] pc;
	
	// if clock posedge and wpcir
	// pc = npc
	// npc is selected in IF stage
   dffe32 next_pc(npc, clock, resetn, wpcir, pc);

endmodule