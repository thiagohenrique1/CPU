module uart_sender(tx, sending, data, send, clk);
	input clk, send;
	input [7:0] data;
	output reg tx, sending;
	
	reg [9:0] data_to_send;
	reg [3:0] bit;
	
	always @(posedge clk) begin
		if(~sending) begin
			if(send) begin
				data_to_send = {1'b1, data, 1'b0};
				sending = 1;
				bit = 0;
			end else tx = 1;
		end else begin
			if(bit == 10) sending = 0;
			else begin
				tx = data_to_send[bit];
				bit = bit + 1;
			end
		end
	end
	
endmodule
