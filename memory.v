module memory(clk, data_in, data_out, addr, write,
				  out1, out2, in1);
	parameter WORD_SIZE = 16, MEMORY_SIZE = 50;
	input clk, write;
	input [WORD_SIZE-1:0] data_in, addr, in1;
	output [WORD_SIZE-1:0] data_out, out1, out2;
	
	reg [WORD_SIZE-1:0] memory_data[MEMORY_SIZE-1:0];
	
	always @(posedge clk) begin
		if(write) memory_data[addr] <= data_in;
		memory_data[47] = in1;
	end
	
	assign data_out = memory_data[addr];
	
	assign out1 = memory_data[49];
	assign out2 = memory_data[48];
	

	integer i;
	initial begin
		for(i = 0; i < MEMORY_SIZE; i=i+1) begin
			memory_data[i] = 0;
		end
		$readmemb("instructions.txt",memory_data);
	end
	
endmodule
