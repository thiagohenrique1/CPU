module datapath(clk, ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux,
					 reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write,
					 reg_write, PC_write, IR_write,
					 memory_in, memory_addr, memory_out,
					 opcode, status_reg);
	
	parameter WORD_SIZE = 16, ALU_OP_SIZE = 3, REG_ADDR_SIZE = 3;
	
//	Clock and reset
	input clk;
	
//	Mux select
	input mem_out_mux;
	input [1:0] ALU_in2_mux, PC_mux, memory_addr_mux, data_in_mux;
	
//	Register write
	input reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write;
	input reg_write, PC_write, IR_write;
	
//	Memory input/output/addr
	input [WORD_SIZE-1:0] memory_in;
	output [WORD_SIZE-1:0] memory_addr, memory_out;
	
//	Control unit data
	output [4:0] opcode;
	output reg [WORD_SIZE-1:0] status_reg;
	
//	Registers
	reg [WORD_SIZE-1:0] ALU_out_buff, PC, inst_reg;
	
//	Wires
	wire [WORD_SIZE-1:0] ALU_out, ALU_flags, ALU_in2, PC_in_wire;
	wire [WORD_SIZE-1:0] reg_buff1, reg_buff2, data_in;
	wire [REG_ADDR_SIZE-1:0] reg_addr1, reg_addr2, reg_addr_in;
	wire [ALU_OP_SIZE-1:0] ALU_op;
	wire [10:0] imm1;
	wire [7:0] imm2;
	wire [4:0] imm3;

//	Register file and mux
	mux2 reg_file_mux(data_in, data_in_mux, ALU_out_buff, memory_in, imm2, PC);
	register_file registers(reg_buff1, reg_buff2, reg_write, reg_addr1, reg_addr2,
									reg_addr_in, data_in, clk, reg_buff1_write, reg_buff2_write);
	
//	ALU, input mux and buffers
	ALU alu(ALU_out, ALU_flags, ALU_op, reg_buff1, ALU_in2);
	
	//assign ALU_in2 = ALU_in2_mux ? reg_buff2 : imm3;
	mux2 ALU_mux(ALU_in2, ALU_in2_mux, reg_buff2, imm3, imm2, 0);
	
	always@(posedge clk) if(ALU_out_write) ALU_out_buff <= ALU_out;
	always@(posedge clk) if(status_reg_write) status_reg <= ALU_flags;
	
//	IR input and decoder
	ir_decode ir_decode(inst_reg, reg_addr2, reg_addr1, reg_addr_in,
				 imm1, imm2, imm3, ALU_op, opcode);
	
	always@(posedge clk) if(IR_write) inst_reg <= memory_in;
	
//	PC mux and input
	mux2 PC_mux2(PC_in_wire, PC_mux, PC+1, imm1, reg_buff1, 0);
	always@(posedge clk) if(PC_write) PC <= PC_in_wire;
	
//	Memory addr and output mux
	mux2 Memory_mux2(memory_addr, memory_addr_mux, PC, reg_buff1, imm2, ALU_out_buff);
	assign memory_out = (mem_out_mux) ? reg_buff1 : reg_buff2;
	
	initial PC = 0;
	
endmodule
