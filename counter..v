module counter(count, in);
	parameter SIZE = 4;
	input in;
	output reg [SIZE-1:0] count;
	
	always@(posedge in) begin
		count = count + 1;
	end

endmodule
