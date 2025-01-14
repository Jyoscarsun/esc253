
module mux7to1(input logic [2:0] MuxSelect, input logic [6:0] MuxIn, output logic Out);
	always_comb // declare always_comb block
	begin
		case ( MuxSelect ) // start case statement
			3'b000 : Out = MuxIn [0]; // Case 0
			3'b001 : Out = MuxIn [1]; // Case 1
			3'b010 : Out = MuxIn [2]; // Case 2
			3'b011 : Out = MuxIn [3]; // Case 3
			3'b100 : Out = MuxIn [4]; // Case 4
			3'b101 : Out = MuxIn [5]; // Case 5
			3'b110 : Out = MuxIn [6]; // Case 6
			default : Out = 0; // Default Case set arbitrarily
		endcase
	end
endmodule

