`timescale 1ns/1ps
module full_cpu_test;
	reg clk;
	wire [15:0] memory_in;
	wire [15:0] memory_out, memory_addr;
	wire memory_write;
	integer i;
	
	CPU cpu(clk, memory_in, memory_addr, memory_out, memory_write);
	
	reg [15:0] memory[30:0];
	wire [15:0] addr20, addr22;
	assign memory_in = memory[memory_addr];
	assign addr20 = memory[20];
	assign addr22 = memory[22];
	
	initial begin
		$dumpfile("dump_full_cpu.vcd");
		$dumpvars;
		
		for (i = 0; i < 8; i = i + 1)
			$dumpvars(0, full_cpu_test.cpu.datapath.registers.reg_file[i]);
		
		clk = 0;
		`include "instructions.v"
		
		#10000 $finish;
	end
	
	always @(posedge clk) begin
		if(memory_write) memory[memory_addr] = memory_out;
	end

	always #20 clk = ~clk;
endmodule 
