// pipe EXE stage
//包含 ALU 及多个多路器等。
module pipeexe_E_stage (ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu );

	 input 		   ealuimm,eshift,ejal;
	 input [3:0]   ealuc;
    input [4:0]   ern0;
	 input [31:0]  ea,eb,eimm,epc4;

	 output [4:0]  ern;
	 output [31:0] ealu;
    
    wire [31:0]   alua,alub,sa,ealur,epc8;
    wire 			zero;
	 // sa and eimm is combined in pipe_cu
    mux2x32 e_alu_a(ea, eimm, eshift, alua);
    mux2x32 e_alu_b(eb, eimm, ealuimm, alub);
	 alu alu_unit(alua,alub,ealuc,ealur,zero);
	 
	 assign epc8 = epc4 + 32'h4;   // jal : r31 <-- pc8
	 assign ern = ern0 | {5{ejal}}; 
	 
    mux2x32 e_choose_epc(ealur,epc8,ejal,ealu);
	 
endmodule