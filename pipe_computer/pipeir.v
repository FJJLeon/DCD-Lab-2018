// pipe IF/ID reg
// 在 clock 上升沿时，将 IF 阶段需传递给 ID 阶段的信息，
// 锁存在 IF/ID 流水线寄存器中，并呈现在 ID 阶段。
module pipeir_D_reg (pc4, ins, wpcir, clock, resetn, dpc4, inst);
	// ins: input, may be blocked by wpcir
	// inst: output, will be used after
	input  [31:0] pc4, ins;
	input         wpcir, clock, resetn;
	output [31:0] dpc4, inst;

	dffe32 pc4_d (pc4, clock, resetn, wpcir, dpc4);
	dffe32 ins_d (ins, clock, resetn, wpcir, inst);
	
endmodule