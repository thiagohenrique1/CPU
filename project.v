module project(led, seg, dig, bt, clk, rx, tx, reset_bt);
	parameter WORD_SIZE = 16;
	input clk, rx, reset_bt;
	output tx;
	input [3:0] bt;
	output [7:0] seg;
	output [3:0] dig, led;

//	Memory wires
	wire [WORD_SIZE-1:0] cpu_to_memory, memory_to_cpu, memory_addr, memory_write, debug;
	wire [WORD_SIZE-1:0] mem_to_sev_seg, mem_to_led, button_to_mem;
	wire [3:0] in;
	wire reset;
	
//	Uart wires
	wire [7:0] uart_to_mem;
	wire baud, baud_tx, uart_new_data_flag;
	
	CPU cpu(clk, reset, memory_to_cpu, memory_addr, cpu_to_memory, memory_write);

	memory mem(clk, cpu_to_memory, memory_to_cpu, memory_addr, memory_write,
				  mem_to_sev_seg, mem_to_led, button_to_mem, uart_to_mem, uart_new_data_flag);
	
	baud_generator baud_gen(clk, baud, baud_tx);
	uart uart_rx(baud, reset, rx, uart_to_mem, uart_new_data_flag);		
		
//	Counter - Slower clock
	wire [16:0] slow_clk;
	counter #(17) counter_clk(slow_clk, clk, 0);

//	Remove button jitter
	debouncer deb({reset,in}, {reset_bt,bt}, slow_clk[16]);

//	Show out1 on 7 segment display
	seven_seg sseg(slow_clk[12], seg, dig, mem_to_sev_seg);
	
// Show out2 on LEDs
	assign led = ~mem_to_led[3:0];

//	Map buttons to in1
	assign button_to_mem = {12'b0, in};

endmodule
