module num2sevenseg(num, sevenseg0, sevenseg1);
	input  [31:0] num;
	output [6:0]  sevenseg0,sevenseg1;
	
	reg [3:0] units,tens;
	
	sevenseg high(tens, sevenseg0);
	sevenseg low(units, sevenseg1);
	
	always @(*)
		begin
			units <= num % 10;
			tens  <= (num % 100) / 10;
		end
	
endmodule