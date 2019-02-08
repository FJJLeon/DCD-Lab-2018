// pipe MEM stage for IO 2
module pipemem_M_stage2(mwmem, malu, mb, ram_clock, resetn, mmo, 
						  swleft5, swright5, key3, key2, key1, data0, data1, data2, led);

	input         mwmem, ram_clock, resetn;
	input  [31:0] malu, mb;
	input  [4:0]  swleft5, swright5;
	input         key3, key2, key1;
	
	output [31:0] mmo;
	output [31:0] data0, data1, data2;
	output [9:0]  led;
	
	IO_datamem2 datamem(malu, mb, mmo, mwmem, ram_clock, resetn,
							 swleft5, swright5, key3, key2, key1, data0, data1, data2, led);
endmodule

module IO_datamem2(addr, datain, dataout, we, ram_clock, resetn,
						swleft5, swright5, key3, key2, key1, data0, data1, data2, led);
						
	input              we, ram_clock, resetn;
	input      [31:0]  addr, datain;
	input      [4:0]   swleft5, swright5;
	// key0 is used for reset
	input              key3, key2, key1;
	
	output reg [31:0]  dataout;
	output reg [31:0]  data0, data1, data2;
	output reg [9:0]   led;
	
	wire 					 write_enable;
	wire       [31:0]  mem_dataout;
	
	assign write_enable = we & (addr[31:8] != 24'hffffff);
	
	lpm_ram_dq_dram dram(addr[6:2], ram_clock, datain, write_enable, mem_dataout);
 	
	// IO ports design.
	always @(posedge ram_clock or negedge resetn) begin
		if (!resetn) begin // reset
			data0 <= 32'h00000000;
			data1 <= 32'h00000000;
			data2 <= 32'h00000000;
			led <= 10'b0000000000;
		end else if (we) begin // write when ram_clock posedge
			case (addr)
				32'hffffff50: data0 <= datain;
				32'hffffff60: data1 <= datain;
				32'hffffff70: data2 <= datain;
				32'hffffff80: led <= datain[9:0];
			endcase
		end
	end

	always @(*) begin // read
		case (addr)
			32'hffffff00: dataout = {27'b0, swleft5};
			32'hffffff10: dataout = {27'b0, swright5};
			32'hffffff20: dataout = {31'b0, key1}; 
			32'hffffff30: dataout = {31'b0, key2};
			32'hffffff40: dataout = {31'b0, key3};
			default: dataout = mem_dataout;
		endcase
	end

endmodule


	
	
	
	
	
	
	
	
	
	
	
	