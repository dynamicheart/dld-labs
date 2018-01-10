module alu (a,b,aluc,s,z);
   input [31:0] a,b;
   input [3:0] aluc;
   output [31:0] s;
   output        z;
   reg [31:0] s;
   reg        z;
	integer i = 0;
	reg [31:0] hamd;
   always @ (a or b or aluc)
      begin                                   // event
         casex (aluc)
             4'b0000: s = a + b;              //x000 ADD
             4'b0100: s = a - b;              //x100 SUB
             4'b0001: s = a & b;              //x001 AND
             4'b0101: s = a | b;              //x101 OR
             4'b0010: s = a ^ b;              //x010 XOR
             4'b0110: s = b << 16;            //x110 LUI: imm << 16bit
				 4'b1000:
					begin
						hamd = 0;
						for (i=0; i<32; i=i+1)
							begin
								if(a[i] != b[i]) hamd = hamd + 1;
							end
						s = hamd;
					end
             4'b0011: s = b << a;             //0011 SLL: rd <- (rt << sa)
             4'b0111: s = b >> a;             //0111 SRL: rd <- (rt >> sa) (logical)
             4'b1111: s = $signed(b) >>> a;   //1111 SRA: rd <- (rt >> sa) (arithmetic)
             default: s = 0;
         endcase
         if (s == 0 )  z = 1;
            else z = 0;
      end
endmodule
