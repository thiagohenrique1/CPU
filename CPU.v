module CPU(clk, memory_in, memory_addr, memory_out, memory_write);
	parameter WORD_SIZE = 16, ALU_OP_SIZE = 3, REG_ADDR_SIZE = 3;

//	Clock
	input clk;
//	Memory input/output/addr/flag
	input [WORD_SIZE-1:0] memory_in;
	output [WORD_SIZE-1:0] memory_addr, memory_out;
	output memory_write;

//	Mux select
	wire ALU_in2_mux, mem_out_mux;
	wire [1:0] PC_mux, memory_addr_mux, data_in_mux;
//	Register write
	wire reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write;
	wire reg_write, PC_write, IR_write;
//	Control unit data
	wire [4:0] opcode;
	wire [WORD_SIZE-1:0] status_reg;

	control_unit control_unit(clk, ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux,
					 reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write,
					 reg_write, PC_write, IR_write, memory_write, opcode, status_reg);
	
	datapath datapath(clk, ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux,
				reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write,
				reg_write, PC_write, IR_write,
				memory_in, memory_addr, memory_out,
				opcode, status_reg);
	
endmodule
