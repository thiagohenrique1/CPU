module mux2(out, select, in0, in1, in2, in3);

	parameter WORD_SIZE = 16;
	
	output reg [WORD_SIZE-1:0] out;
	input [WORD_SIZE-1:0] in0, in1, in2, in3;
	input [1:0] select;
	
	always@* begin
		case(select)
			2'b00: out = in0;
			2'b01: out = in1;
			2'b10: out = in2;
			2'b11: out = in3;
		endcase
	end
endmodule
