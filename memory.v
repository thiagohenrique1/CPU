module memory(clk, data_in, data_out, addr, write,
				  out1, out2, in1, out_uart, send_uart, in_uart, uart_new_data);
	parameter WORD_SIZE = 16, MEMORY_SIZE = 128;
	parameter sev_seg_addr = 127, led_addr = 126, bt_addr = 125;
	parameter out_uart_addr = 124, send_uart_addr = 123, in_uart_addr = 122, uart_new_data_addr = 121;
	
	input clk, write, uart_new_data;
	input [WORD_SIZE-1:0] data_in, addr, in1;
	input [7:0] in_uart;
	output [WORD_SIZE-1:0] data_out, out1, out2;
	output [7:0] out_uart;
	output send_uart;
	
	reg uart_new_data_prev;
	reg [WORD_SIZE-1:0] memory_data[MEMORY_SIZE-1:0];
	
	always @(posedge clk) begin
		if(write && addr > 16'h18) memory_data[addr] <= data_in;
		
//		Put button value on memory
		memory_data[bt_addr] = in1;
		
//		Put new uart data on memory and set flag
		if(~uart_new_data_prev && uart_new_data) memory_data[uart_new_data_addr] = 1;
		else if(addr == in_uart_addr) memory_data[uart_new_data_addr] = 0;
		if(memory_data[uart_new_data_addr]) memory_data[in_uart_addr] = in_uart;
		uart_new_data_prev = uart_new_data;
	end
	
	assign data_out = memory_data[addr];
	
	assign out1 = memory_data[sev_seg_addr];
	assign out2 = memory_data[led_addr];

	integer i;
	initial begin
		for(i = 0; i < MEMORY_SIZE; i=i+1) begin
			memory_data[i] = 0;
		end
		$readmemb("instructions.txt",memory_data);
	end
	
endmodule
