// pipe MEM/WB reg
module pipemwreg_W_reg (mwreg,mm2reg,mmo,malu,mrn,
							   clk,resetn,
							   wwreg,wm2reg,wmo,walu,wrn);	

    input 		  clk,resetn;
	 input [4:0]  mrn;
    input [31:0] mmo,malu;
    input 		  mwreg,mm2reg;
    
	 output reg [4:0]  wrn;
	 output reg 		 wwreg,wm2reg;
    output reg [31:0] wmo,walu;
    
    always @ (posedge clk or negedge resetn)
		begin
			if(resetn == 0) begin
				wwreg   <= 0;
				wm2reg  <= 0;
				wmo     <= 0;
				walu    <= 0;
				wrn     <= 0;
			end else begin 
				wwreg   <= mwreg ;
				wm2reg  <= mm2reg;
				wmo     <= mmo   ;
				walu    <= malu  ;
				wrn     <= mrn   ;
			end
		end
		
endmodule 