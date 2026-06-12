module MUX2x1(input [31:0] a, b, 
				  input Sel,
					output [31:0] Out);
					
			assign Out = Sel ? b:a;
	endmodule
			