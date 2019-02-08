`timescale 1ps/1ps

module pipe_computer_sim2;
	reg         resetn, clock;
	reg         mem_clock;
	wire [31:0] pc, ins, dpc4, inst, da, db, dimm, ealu, eb, mmo, wdi;
	wire [31:0] pc_sim,inst_sim, ealu_sim, malu_sim, walu_sim;
	wire [4:0]  drn, ern, mrn, wrn;
	reg  [9:0]  sw;
	reg  [4:0]  swleft5, swright5;
	reg  [3:1]  key;
	reg         key3, key2, key1;
	wire [6:0]  hex5, hex4, hex3, hex2, hex1, hex0;
	wire [31:0] data0, data1, data2;
	wire [9:0]  led;
/*
	pipelined_computer pipe_computer_instance(resetn, clock, mem_clock,
		pc_sim, inst_sim, ealu_sim, malu_sim, walu_sim,
		sw, key, hex5, hex4, hex3, hex2, hex1, hex0, led);
*/

	pipelined_computer pipe_computer_instance(resetn, clock, mem_clock,
		pc_sim, inst_sim, ealu_sim, malu_sim, walu_sim,
		swleft5, swright5, key3, key2, key1, data0, data1, data2, led);
	
	out_port_seg data0TOhex54(data0, hex5, hex4);
	out_port_seg data1TOhex32(data1, hex3, hex2);
	out_port_seg data2TOhex10(data2, hex1, hex0);
	
	initial begin // Generate clock.
		clock = 1;
		while (1)
			#2 clock = ~clock;
	end
	
	always @ ( * ) 
		  begin
				mem_clock = ~clock;
		  end

	initial begin // Generate a reset signal at the start.
		resetn = 1;
		#1 resetn = 0;
		#5 resetn = 1;

	end
	
	initial begin 
		swleft5  = 5'b01101;
		swright5 = 5'b11100;
	end
endmodule
	
/*
	initial begin // Simulate switch changes.
		sw <= 10'b1010101010;
		while (1)
			#2400 sw = ~sw;
	end

	initial begin // Simulate key presses.
		key3 <= 1;
		key2 <= 1;
		key1 <= 1;
		while (1) begin
			$display($time,"key=%b",key3);
			#800 key2 <= 0; // key2 pressed, should change to sub mode
			$display($time,"key=%b",key2);
			#800 key1 <= 0; // key1 pressed, should change to xor mode
			$display($time,"key=%b",key1);
			#800 key3 <= 0; // key3 pressed, should change to add mode
		end
	end
*/
/*
	initial begin // Simulate key presses.
		key <= 3'b111;
		while (1) begin
			$display($time,"key=%b",key);
			#800 key <= 3'b101; // key2 pressed, should change to sub mode
			$display($time,"key=%b",key);
			#800 key <= 3'b110; // key1 pressed, should change to xor mode
			$display($time,"key=%b",key);
			#800 key <= 3'b011; // key3 pressed, should change to add mode
		end
	end

	
endmodule
*/