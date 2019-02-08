// pipe ID stage
// 其中包含控制器 CU、寄存器堆及多个多路器等。
// 其中的寄存器堆，会在系统 clock 的下沿进行寄存器写入，也就是给信号从 WB 阶段
// 传输过来留有半个 clock 的延迟时间，亦即确保信号稳定。
// 该阶段 CU 产生的，要传播到流水线后级的信号较多。
module pipeid_D_stage (mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
		wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,
		bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
		daluimm,da,db,dimm,drn,dshift,djal);
	
	input 		 clock, resetn;
	input			 mwreg, ewreg, em2reg, mm2reg, wwreg;
	input [4:0]  ern, mrn, wrn; // 
	input [31:0] dpc4, inst, wdi, ealu, malu, mmo;

	output 		  wpcir, dwreg, dm2reg, dwmem, daluimm, dshift, djal;
	output [1:0]  pcsource;
	output [3:0]  daluc;
	output [4:0]  drn;
	output [31:0] bpc, jpc, da, db, dimm;
	
	wire [31:0] qa,qb;
	wire [1:0]  fwda,fwdb;
	wire  		usert,sext,rsrtequ;
	
	wire [5:0]  op,func;
	wire [4:0]  rs,rt,rd;
	wire [15:0] imm;
	wire [25:0] addr;
	wire [31:0] sa;
	//divide inst
	// R:31--26 25--21 20--16 15--11 10--6 5--0 
	//     op     rs     rt     rd     sa  func
	// I:31--26 25--21 20--16 15--------------0
	//     op     rs     rt         imm
	// J:31--26 25----------------------------0
	//     op                addr
	assign op = inst[31:26];
	assign func = inst[5:0];
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	assign imm = inst[15:0];
	assign addr = inst[25:0];
	assign sa = {27'b0, inst[10:6]}; // zero extend sa to 32 bit for shift inst
	
	wire        e = sext & inst[15];  // the bit in imm for extend
	wire [15:0] prefix = {16{e}};	// 16 bits sign extend for imm
	wire [31:0] branch_off = {prefix[13:0], imm, 2'b00}; // branch addr offset for bne\beq
	wire [31:0] extend_imm = {prefix, imm};
	// wire:rsrtequ = (da == db),
   //	da select from qa, ealu, malu, mmo
	// forwarding controlled by CU
	assign rsrtequ = da == db;
	// jpc = dpc4[31..28] + (addr << 2)[27..0]
	// for j\jal
	assign jpc = {dpc4[31:28], addr, 2'b00};
	// bpc = dpc4 + (sign)imm << 2
	assign bpc = dpc4 + branch_off;
	// dimm = sigend extent inst[15..0]
	//assign dimm = {{16{e}},inst[15:0]};
	assign dimm = op == 6'b000000 ? sa : extend_imm;
	//cu
	pipe_cu cu(op, func, rs, rt, mrn, mm2reg, mwreg, ern, em2reg, ewreg,
					rsrtequ, pcsource, wpcir, dwreg, dm2reg, dwmem, djal, daluc, daluimm,
					dshift, regrt, sext, fwdb, fwda);
	//regfile
	regfile regf(rs, rt, wdi, wrn, wwreg, clock, resetn, qa, qb);
	//select drn
	mux2x5 rd_rt(rd,rt,regrt,drn);
	//select da
	mux4x32 select_a (qa,ealu,malu,mmo,fwda,da);
	//select db
	mux4x32 select_b (qb,ealu,malu,mmo,fwdb,db);
endmodule