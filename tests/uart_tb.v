module uart_tb;
	reg clk, b, reset;
	reg [3:0] ct;
	reg [3:0] bt;
	reg [11:0] d;
	wire tx, ready;
	wire [7:0] data;
	
	uart uart1(clk, reset, b, tx, data, ready);

	initial begin
		$dumpfile("dump_uart.vcd");
		$dumpvars;
		ct = 0;
		clk = 0;
		b = 1;
		bt = 0;
		d = 11'b11011101001;
		reset = 1;
		#1 reset = 0;
		
		#10000 $finish;
	end

	always begin
		#10 ct = ct + 1;
		clk = 1;
		#1 clk = 0;

		if(ct == 0) begin
			b = d[bt];
			bt = bt + 1;
		end
	end
	
	task clock;
	begin
		clk = 0;
		#10 clk = 1;
		#10;
	end
	endtask
endmodule
 
