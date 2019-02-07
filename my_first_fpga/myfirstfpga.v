// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
// CREATED		"Sat Nov 10 17:13:33 2018"

module myfirstfpga(
	CLOCK_50,
	KEY,
	LED
);


input wire	CLOCK_50;
input wire	[1:0] KEY;
output wire	[3:0] LED;

wire	[31:0] counter;
wire	[3:0] result;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;





simple_counter	b2v_inst(
	.CLOCK_50(SYNTHESIZED_WIRE_0),
	.counter_out(counter));


pll	b2v_inst1(
	.refclk(CLOCK_50),
	.rst(SYNTHESIZED_WIRE_1),
	.outclk_0(SYNTHESIZED_WIRE_0));


counter_bus_mux	b2v_inst2(
	.sel(KEY[0]),
	.data0x(counter[24:21]),
	.data1x(counter[26:23]),
	.result(result));

assign	SYNTHESIZED_WIRE_1 =  ~KEY[1];

assign	LED = result;

endmodule
