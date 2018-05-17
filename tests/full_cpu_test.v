module full_cpu_test;
	reg clk;
	reg [15:0] memory_in;
	wire [15:0] memory_out, memory_addr;
	wire memory_write;
	
	CPU cpu(clk, memory_in, memory_addr, memory_out, memory_write);
	
	initial begin
		$dumpfile("dump_full_cpu.vcd");
		$dumpvars;
		clk = 0;
		memory_in = 5'b10110;
		#40 memory_in = 16'b1101001011100011;
		
		#300 $finish;
	end

	always #10 clk = ~clk;
endmodule 
