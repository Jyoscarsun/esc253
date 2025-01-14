module FF(input logic D, reset, clk, output logic Q);
		always_ff@(posedge clk)
		begin
			if(reset == 1) Q <= 1'b0;
			else Q <= D;
		end
endmodule

module register(input logic RotateRight, ParallelLoadn, D, clk, reset, Right_in, Left_in, output logic Q);
		logic w1, w2;
		
		assign w1 = RotateRight ?  Left_in: Right_in;
		assign w2 = ParallelLoadn ? w1 : D;
		
		// assign x = (logical statement) ? value_if_true : value_if_false;
		always_ff@(posedge clk)
			begin
				if(reset) Q <= 1'b0;
				else Q <= w2;
			end 
endmodule

module part1(input logic clock, reset, ParallelLoadn, RotateRight, ASRight, input logic [3:0] Data_IN, output logic [3:0] Q);
	logic q0, q1, q2, q3, r;
	
	register R0(
		.clk(clock),
		.reset(reset),
		.RotateRight(RotateRight),
		.ParallelLoadn(ParallelLoadn),
		.D(Data_IN[0]),
		.Q(q0),
		.Right_in(q3),
		.Left_in(q1)
	);
	
	register R1(
		.clk(clock),
		.reset(reset),
		.RotateRight(RotateRight),
		.ParallelLoadn(ParallelLoadn),
		.D(Data_IN[1]),
		.Q(q1),
		.Right_in(q0),
		.Left_in(q2)
	);
	
	register R2(
		.clk(clock),
		.reset(reset),
		.RotateRight(RotateRight),
		.ParallelLoadn(ParallelLoadn),
		.D(Data_IN[2]),
		.Q(q2),
		.Right_in(q1),
		.Left_in(q3)
	);
	
	register R3(
		.clk(clock),
		.reset(reset),
		.RotateRight(RotateRight),
		.ParallelLoadn(ParallelLoadn),
		.D(Data_IN[3]),
		.Q(q3),
		.Right_in(q2),
		.Left_in(r)
	);
	
	assign r = (RotateRight & ASRight) ? q3 : q0;
	assign Q = {q3,q2,q1,q0};
	
endmodule
