module pipemem (we,addr,datain,clk,mem_clk,dataout,clrn,out_port0,out_port1,out_port2,in_port0,in_port1,mem_dataout,io_read_data);
	input [31:0] addr,datain;
	input clk,we,mem_clk;
	output [31:0] dataout;

	wire write_enable =we & ~clk;
	
	input clrn;
	input [4:0] in_port0,in_port1;
	output [31:0] out_port0,out_port1,out_port2;
	output [31:0] mem_dataout;
	output [31:0] io_read_data;
	wire [31:0] dataout;
	wire write_datamem_enable;
	wire [31:0] mem_dataout;
	
	wire dmem_clk;
	assign dmem_clk = mem_clk & ( ~ clk) ; //注意

	assign write_datamem_enable = write_enable & ( ~ addr[7]); //注意
	assign write_io_output_reg_enable = write_enable & ( addr[7]); //注意
	mux2x32 mem_io_dataout_mux(mem_dataout,io_read_data,addr[7],dataout);

	lpm_ram_dq_dram dram(addr[6:2],dmem_clk,datain,write_datamem_enable,mem_dataout );

	io_output_reg io_output_regx2 (addr,datain,write_io_output_reg_enable,dmem_clk,clrn,out_port0,out_port1,out_port2);
	
	io_input_reg io_input_regx2(addr,dmem_clk,io_read_data,in_port0,in_port1);
	


endmodule

