`include "CPU.v"

module cpu_tb;
	parameter WORD_SIZE = 16, ALU_OP_SIZE = 3, REG_ADDR_SIZE = 3;
	
//	Clock
	reg clk;
	
//	Mux select
	reg ALU_in2_mux, mem_out_mux;
	reg [1:0] PC_mux, memory_addr_mux, data_in_mux;
	
//	Register write
	reg reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write;
	reg reg_write, PC_write, IR_write;
	
//	Memory in/out/addr
	reg [WORD_SIZE-1:0] memory_in;
	wire [WORD_SIZE-1:0] memory_addr, memory_out;
	
//	Control unit data
	wire [4:0] opcode;
	wire reg [WORD_SIZE-1:0] status_reg;
	
	CPU cpu(clk, ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux,
			  reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write,
			  reg_write, PC_write, IR_write,
			  memory_in, memory_addr, memory_out,
			  opcode, status_reg);
	
	initial begin
		$dumpfile("dump_cpu.vcd");
		$dumpvars;
		dont_write();
		clk = 1;
		#10;
		
		load_ir(16'b1111000001011001); // load_i r1, 11
		data_in_mux = 2;
		reg_write = 1;
		clock();
		
		load_ir(16'b1110100000010001); // store r1, label
		reg_buff1_write = 1;
		clock();
		
		load_ir(16'b1111000000100011); // load_i r3, 4
		data_in_mux = 2;
		reg_write = 1;
		clock();
		
		load_ir(16'b1110100000010011); //store r3, label
		reg_buff1_write = 1;
		clock();
		
		load_ir(16'b0000000011001000); // add r0, r1, r3
		reg_buff1_write = 1;
		reg_buff2_write = 1;
		ALU_in2_mux = 1;
		clock();
		
		ALU_out_write = 1;
		clock();
		
		#20 $finish;
	end
	
	task load_ir;
	input [WORD_SIZE-1:0] inst;
	begin
		memory_in = inst;
		IR_write = 1;
		clock();
	end
	endtask
	
	task clock;
	begin
		clk = 0;
		#10 clk = 1;
		#10;
		dont_write();
	end
	endtask
	
	task dont_write;
	begin
		{reg_buff1_write, reg_buff2_write, status_reg_write, 
		ALU_out_write, reg_write, PC_write, IR_write} = 0;
	end
	endtask
	
endmodule
