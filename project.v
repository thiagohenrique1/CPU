module project(led, seg, dig, bt, clk, rx, tx, reset_bt);
	parameter WORD_SIZE = 16;
	input clk, rx, reset_bt;
	output tx;
	input [3:0] bt;
	output [7:0] seg;
	output [3:0] dig, led;

//	Memory wires
	wire [WORD_SIZE-1:0] cpu_to_memory, memory_to_cpu, memory_addr, memory_write, debug;
	wire [WORD_SIZE-1:0] out1, out2, in1;
	wire [3:0] in;
	wire reset;
	
//	Uart wires
	wire [7:0] received_data, data_to_send;
	wire baud, baud_tx, uart_new_data, send_uart, uart_sending;
	
	CPU cpu(clk, reset, memory_to_cpu, memory_addr, cpu_to_memory, memory_write);

	memory mem(clk, cpu_to_memory, memory_to_cpu, memory_addr, memory_write,
				  out1, out2, in1, data_to_send, uart_send, received_data, uart_new_data);
	
	baud_generator baud_gen(clk, baud, baud_tx);
	uart uart_rx(baud, reset, rx, received_data, uart_new_data);
	uart_sender uart_tx(tx, uart_sending, data_to_send, uart_send, baud_tx);		

		
//	Prescaler
	parameter PRESC_SIZE = 37;
	wire [PRESC_SIZE-1:0] presc;
	counter #(PRESC_SIZE) prescaler(presc, clk, 0);

//	Remove button jitter
	debouncer deb({reset,in}, {reset_bt,bt}, presc[16]);

//	Show out1 on 7 segment display
	seven_seg sseg(presc[12], seg, dig, out1);
	
// Show out2 on LEDs
	assign led = ~out2[3:0];

//	Map buttons to in1
	assign in1 = {12'b0, in};

endmodule
