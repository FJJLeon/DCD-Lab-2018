module sc_datamem (addr,datain,dataout,we,clock,mem_clk,dmem_clk,	
	               out_port0,out_port1,out_port2,in_port0,in_port1,mem_dataout,io_read_data );
 
   input  [31:0]  addr;
   input  [31:0]  datain;
   input          we, clock,mem_clk;
   input  [31:0]   in_port0,in_port1;

   output [31:0]  dataout;
   output         dmem_clk;
	output [31:0]  out_port0,out_port1,out_port2;
	output [31:0]  mem_dataout;
	output [31:0]  io_read_data;
   
   wire [31:0] dataout; //final out data
   wire        dmem_clk;

   wire        write_enable; 
	wire        write_datamem_enable;
	wire [31:0] mem_dataout;
	
	wire        write_io_enable;
	
   assign      write_enable = we & ~clock; 
   assign      dmem_clk = mem_clk & ( ~ clock); 
	//100000-111111:I/O ; 000000-011111:data
	assign      write_datamem_enable = write_enable & (~addr[7]);  //note, enable mem
	assign      write_io_enable = write_enable & addr[7];          //note, enable IO
   
	mux2x32 io_data_mux(mem_dataout,io_read_data,addr[7],dataout);
	// module mux2x32
	// when addr[7] = 0, access datamem, dataout is mem_dataout
      // the address space of datamem is from 000000 to 011111 word(4 bytes) 
   // when addr[7] = 1, access in_port, dataout is io_read_data
      // the address space of I/O is from 100000 to 111111 word(4 bytes) 

   lpm_ram_dq_dram  dram(addr[6:2],dmem_clk,datain,write_datamem_enable,mem_dataout );
   // module lpm_ram_dq_dram
	io_output io_output_reg(addr,datain,write_io_enable,dmem_clk,out_port0,out_port1,out_port2);
	io_input io_input_reg(addr,dmem_clk,io_read_data,in_port0,in_port1);
	
endmodule