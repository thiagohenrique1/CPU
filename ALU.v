module ALU(out, flags, op, in_a, in_b);

	parameter WORD_SIZE = 16, OP_SIZE = 3;
	
	output reg[WORD_SIZE-1:0] out;
	output[WORD_SIZE-1:0] flags;
	input[OP_SIZE-1:0] op;
	input[WORD_SIZE-1:0] in_a;
	input[WORD_SIZE-1:0] in_b;
	
	always@(op,in_a,in_b) begin
		case(op)
			1'b0: out = in_a + in_b;
			1'b1: out = in_a - in_b;
			2'b10: out = ~in_a;
			2'b11: out = in_a & in_b;
			3'b100: out = in_a | in_b;
			3'b101: out = in_a ^ in_b;
			3'b110: out = in_a * in_b;
			3'b111: out = in_a >> in_b;
		endcase
	end
	
	assign flags[WORD_SIZE-1:3] = 0;
	assign flags[0] = (in_a == in_b);
	assign flags[1] = (in_a >= in_b);
	assign flags[2] = (out == 0);
endmodule