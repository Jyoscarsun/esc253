module mux2to1(input logic MuxSelect, input logic [1:0] MuxIn, output logic Out);
		always_comb // declare always_comb block
		begin
			case ( MuxSelect ) // start case statement
				1'b0 : Out = MuxIn [0]; // Case 0
				1'b1 : Out = MuxIn [1]; // Case 1
				default : Out = 0; // Default Case set arbitrarily
			endcase
		end
endmodule

module FA(input logic a, b, c_i, output logic c_0, s);
		logic w1;
		
		assign w1 = a ^ b;
		assign s = w1 ^ c_i;
		
		mux2to1 C1(
			.MuxSelect(w1),
			.MuxIn({c_i, b}),
			.Out(c_0)
		);
		
endmodule


module part1(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);		
		FA FA0(
			.a(a[0]),
			.b(b[0]),
			.c_i(c_in),
			.c_0(c_out[0]),
			.s(s[0])
		);
		
		FA FA1(
			.a(a[1]),
			.b(b[1]),
			.c_i(c_out[0]),
			.c_0(c_out[1]),
			.s(s[1])
		);
		
		FA FA2(
			.a(a[2]),
			.b(b[2]),
			.c_i(c_out[1]),
			.c_0(c_out[2]),
			.s(s[2])
		);
		
		FA FA3(
			.a(a[3]),
			.b(b[3]),
			.c_i(c_out[2]),
			.c_0(c_out[3]),
			.s(s[3])
		);
endmodule