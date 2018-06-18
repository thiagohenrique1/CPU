module debouncer(out, in, clk);
	input [4:0] in;
	input clk;
	output reg [4:0] out;
	
	reg [4:0] prev;
	reg [6:0] count;

	always@(posedge clk) begin
		if(in == prev) begin
			if(count == 4'b1111111) begin
				count = 0;
				out = ~in;
			end
			else count = count + 1;
		end
		else count = 0;
		
		prev = in;	
	end
endmodule