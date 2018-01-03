module pipepc( npc,wpcir,clk,resetn,pc );
   input  [31:0] npc;
   input  wpcir,clk,resetn;
   output [31:0] pc;
	
   dffe32 next_pc(npc,clk,resetn,wpcir,pc);
endmodule
