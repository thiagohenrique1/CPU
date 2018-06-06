`timescale 1ns/1ps
module project_test;
	reg clk;
	integer i;
	
	parameter WORD_SIZE = 16;
	wire rx, tx, reset;
	reg [3:0] bt;
	wire [7:0] seg;
	wire [3:0] dig, led;
	
	project project1(led, seg, dig, bt, clk, rx, tx, reset);
	
	initial begin
		$dumpfile("dump_project.vcd");
		$dumpvars;
		
		for (i = 0; i < 8; i = i + 1)
			$dumpvars(0, project_test.project1.cpu.datapath.registers.reg_file[i]);
		
		force project_test.project1.in1 = 5;
		
		clk = 0;
		
		#15000 $finish;
	end

	always #20 clk = ~clk;
endmodule 
