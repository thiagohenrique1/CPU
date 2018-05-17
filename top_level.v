module top_level(led, seg, dig, bt, clk, rx, tx);
	input clk, rx;
	output tx;
	input [3:0] bt;
	output [7:0] seg;
	output [3:0] dig, led;
	wire [3:0] in;
	
//	Prescaler
	parameter PRESC_SIZE = 37;
	wire [PRESC_SIZE-1:0] presc;
	counter #(PRESC_SIZE) prescaler(presc, clk);

	debouncer(in, bt, presc[16]);

	seven_seg(presc[12], seg, dig, 
		{full_data[15:12], full_data[11:8],
		 full_data[7:4], full_data[3:0]});
	
	always @(posedge ready) begin
		if(~byte_select)
			full_data[7:0] = data;
		else
			full_data[15:8] = data;
		byte_select = ~byte_select;
	end
	
	wire [7:0] data;
	wire [7:0] data_send;
	reg [15:0] full_data;
	reg byte_select;
	wire baud, ready, baud_tx, sending, send_flag;
	reg send, last_flag;
	
	baud_generator(clk, baud, baud_tx);
	uart(baud, in[0], rx, data, ready);
	uart_sender(tx, sending, data_send, send, baud_tx);
	
	counter #(8) count(data_send, presc[22]);
	
	assign led = ~data_send[3:0];
	
	assign send_flag = presc[22];
	always @(posedge clk) begin
		if(sending) send = 0;
		else if(send_flag && ~last_flag) send = 1;
		last_flag = send_flag;
	end
	
endmodule