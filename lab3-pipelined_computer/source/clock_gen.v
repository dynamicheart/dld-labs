module clock_gen(origin,cpu_clk,mem_clk);
	input origin;
	output reg cpu_clk;
	output mem_clk;
	
	assign mem_clk = origin;

	always @ (posedge origin)
		cpu_clk <= ~cpu_clk;
	
	initial cpu_clk <= 0;

endmodule