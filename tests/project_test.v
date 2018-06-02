`timescale 1ns/1ps
module project_test;
	reg clk;
	integer i;
	
	parameter WORD_SIZE = 16;
	wire rx, tx;
	reg [3:0] bt;
	wire [7:0] seg;
	wire [3:0] dig, led;
	
	project project1(led, seg, dig, bt, clk, rx, tx);
	
	initial begin
		$dumpfile("dump_project.vcd");
		$dumpvars;
		
		for (i = 0; i < 8; i = i + 1)
			$dumpvars(0, project_test.project1.cpu.datapath.registers.reg_file[i]);
		
		clk = 0;
		//bt[0] = 0;
		//#100 bt[0] = 1;
		//#40 bt[0] = 0;
		
		#2000 $finish;
	end

	always #20 clk = ~clk;
endmodule 
