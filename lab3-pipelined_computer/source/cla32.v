module cla32 (a,b,s,y);
	input [31:0] a,b;
	input s;
	output [31:0] y;
	assign y = s ? a - b : a + b;
endmodule
