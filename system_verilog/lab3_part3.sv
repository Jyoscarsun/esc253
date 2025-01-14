module part3(input logic Clock, Reset_b, input logic [3:0] Data, 
	input logic [2:0] Function, output logic [7:0] ALU_reg_out);
	logic[7:0] ALUout;
	logic[3:0] A, B;
	assign A = Data;
	assign B = ALU_reg_out[3:0];
	
	always_comb
	begin
		case(Function)
			0: ALUout = A+B;
			1: ALUout = A*B;
			2: ALUout = B << A;
			3: ALUout = ALU_reg_out;
			default: ALUout = ALU_reg_out;
		endcase
	end
	
	always_ff@(posedge Clock)
	begin
		if(Reset_b == 1) ALU_reg_out <= 8'b00000000;
		else ALU_reg_out <= ALUout;
	end
endmodule
