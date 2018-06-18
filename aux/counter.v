module counter(count, in, reset);
	parameter SIZE = 4;
	input in, reset;
	output reg [SIZE-1:0] count;
	
	always@(posedge in or posedge reset) begin
		if(reset) count = 0;
		else count = count + 1;
	end
	
	initial count = 0;
	
endmodule
