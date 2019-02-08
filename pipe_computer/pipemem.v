// pipe MEM stage
module pipemem_M_stage(mwmem, malu, mb, ram_clock, resetn, mmo, 
						  sw, key, hex5, hex4, hex3, hex2, hex1, hex0, led);

	input         mwmem, ram_clock, resetn;
	input  [31:0] malu, mb;
	input  [9:0]  sw;
	input  [3:1]  key;
	
	output [31:0] mmo;
	output [6:0]  hex5, hex4, hex3, hex2, hex1, hex0;
	output [9:0]  led;
	
	IO_datamem datamem(malu, mb, mmo, mwmem, ram_clock, resetn,
							 sw, key, hex5, hex4, hex3, hex2, hex1, hex0, led);
endmodule

module IO_datamem(addr, datain, dataout, we, ram_clock, resetn,
						sw, key, hex5, hex4, hex3, hex2, hex1, hex0, led);
						
	input              we, ram_clock, resetn;
	input      [31:0]  addr, datain;
	input      [9:0]   sw;
	input      [3:1]   key;
	
	output reg [31:0]  dataout;
	output reg [6:0]   hex5, hex4, hex3, hex2, hex1, hex0;
	output reg [9:0]   led;
	
	wire 					 write_enable;
	wire       [31:0]  mem_dataout;
	
	assign write_enable = we & (addr[31:8] != 24'hffffff);
	
	lpm_ram_dq_dram dram(addr[6:2], ram_clock, datain, write_enable, mem_dataout);
 	
	// IO ports design.
	always @(posedge ram_clock or negedge resetn) begin
		if (!resetn) begin // reset
			hex0 <= 7'b1111111;
			hex1 <= 7'b1111111;
			hex2 <= 7'b1111111;
			hex3 <= 7'b1111111;
			hex4 <= 7'b1111111;
			hex5 <= 7'b1111111;
			led <= 10'b0000000000;
		end else if (we) begin // write
			case (addr)
				32'hffffff20: hex0 <= datain[6:0];
				32'hffffff30: hex1 <= datain[6:0];
				32'hffffff40: hex2 <= datain[6:0];
				32'hffffff50: hex3 <= datain[6:0];
				32'hffffff60: hex4 <= datain[6:0];
				32'hffffff70: hex5 <= datain[6:0];
				32'hffffff80: led <= datain[9:0];
			endcase
		end
	end

	always @(*) begin // read
		case (addr)
			32'hffffff00: dataout = {22'b0, sw};
			// key0 is used for reset
			32'hffffff10: dataout = {28'b0, key, 1'b1}; 
			default: dataout = mem_dataout;
		endcase
	end

endmodule


	
	
	
	
	
	
	
	
	
	
	
	