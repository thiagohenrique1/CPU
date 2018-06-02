module project(led, seg, dig, bt, clk, rx, tx);
	parameter WORD_SIZE = 16;
	input clk, rx;
	output tx;
	input [3:0] bt;
	output [7:0] seg;
	output [3:0] dig, led;
	
	wire [WORD_SIZE-1:0] cpu_to_memory, memory_to_cpu, memory_addr, memory_write, debug;
	wire [WORD_SIZE-1:0] out1, out2, in1;
	wire [3:0] in;
	reg reset, stop_delay;
	
	CPU cpu(clk, in[0], memory_to_cpu, memory_addr, cpu_to_memory, memory_write);

	memory mem(clk, cpu_to_memory, memory_to_cpu, memory_addr, memory_write,
				  out1, out2, in1);
				  
//	Prescaler
	parameter PRESC_SIZE = 37;
	wire [PRESC_SIZE-1:0] presc;
	counter #(PRESC_SIZE) prescaler(presc, clk, 0);

//	Remove button jitter
	debouncer deb(in, bt, presc[16]);

//	Show out1 on 7 segment display
	seven_seg sseg(presc[12], seg, dig, out1);
	
// Show out2 on LEDs
	assign led = ~out2[3:0];

//	Map buttons to in1
	assign in1 = {12'b0, in};

endmodule
