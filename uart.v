module uart(clk, reset, rx, data, ready);
	input clk, reset, rx;
	output reg ready;
	output reg [7:0] data;

	parameter waiting = 0, wait_stop_bit = 1, reading = 2, stop = 3;
	reg [1:0] state;
	reg [2:0] bit;
	reg [3:0] counter;
	
	always @(posedge clk) begin
		counter = counter + 1;
		
		if(reset) begin
			state = 0;
			data = 0;
			bit = 0;
			ready = 0;
			counter = 0;
		end
		else case(state)
			waiting: begin
				if(rx == 0) begin
					bit = 0;
					state = wait_stop_bit;
				end else counter = 0;
			end
			wait_stop_bit: begin
				if(counter == 0) state = reading;
			end
			reading: begin
				ready = 0;
				if (counter == 4) begin
					data[bit] = rx;
				end
				else if(counter > 4 && counter < 10) begin
					if(rx != data[bit]) state = waiting;
				end 
				else if(counter == 10) begin
					if(bit == 7) state = stop;
					else bit = bit + 1;
				end
			end
			stop: begin
				if(rx == 1 && counter == 4) begin
					ready = 1;
					state = waiting;
				end
			end
		endcase
	end
	
endmodule
