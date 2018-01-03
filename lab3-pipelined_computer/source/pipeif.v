module pipeif( pcsource,pc,bpc,rpc,jpc,npc,pc4,ins,clk,mem_clk );

	input [31:0] pc,bpc,rpc,jpc;
	input [1:0] pcsource;
	input clk,  mem_clk;
	output [31:0] npc,pc4,ins;

	wire          imem_clk;

   assign  imem_clk = clk & ( ~ mem_clk );     
	
	mux4x32 n_pc (pc4,bpc,rpc,jpc,pcsource,npc);
	cla32 pcplus4 (pc,32'h4,1'b0,pc4);
	lpm_rom_irom irom (pc[7:2],imem_clk,ins);

endmodule
