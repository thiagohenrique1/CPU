module baud_generator(clk, baud, baud_tx);
	input clk;
	output reg baud, baud_tx;
	parameter max = 50000000/(115200*16);
	parameter max_tx = 50000000/115200;
	
	reg [4:0] count = 0;
	reg [8:0] count_tx = 0;
	
	always @(posedge clk) begin
		if(count == max) begin
			count = 0;
			baud = 1;
		end else begin
			baud = 0;
			count = count + 1;
		end
	end
	
	always @(posedge clk) begin
		if(count_tx == max_tx) begin
			count_tx = 0;
			baud_tx = 1;
		end else begin
			baud_tx = 0;
			count_tx = count_tx + 1;
		end
	end
	
endmodule
