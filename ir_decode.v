module ir_decode(instruction_reg, reg_addr2, reg_addr1, reg_addr_in,
					  imm1, imm2, imm3, alu_op, opcode);
	
	parameter WORD_SIZE = 16, REG_ADDR_SIZE = 3, ALU_OP_SIZE = 3;
	
	input [WORD_SIZE-1:0] instruction_reg;
	output [REG_ADDR_SIZE-1:0] reg_addr1, reg_addr2, reg_addr_in;
	output [10:0] imm1;
	output [7:0] imm2;
	output [4:0] imm3;
	output [ALU_OP_SIZE-1:0] alu_op;
	output [4:0] opcode;
	
	wire [REG_ADDR_SIZE-1:0] rc, rb, ra;
	assign ra = instruction_reg[2:0];
	assign rb = instruction_reg[5:3];
	assign rc = instruction_reg[8:6];
	assign imm1 = instruction_reg[10:0];
	assign imm2 = instruction_reg[10:3];
	assign imm3 = instruction_reg[10:6];
	assign opcode = instruction_reg[15:11];
	assign alu_op = opcode[2:0];
	
//	Link register addr
	parameter lr = 3'b111;
	
	parameter br_op = 5'b11111, store_op = 5'b11101,
				 store_r_op = 5'b11001, bl_op = 5'b10100;
	
	assign reg_addr1 = (opcode == br_op || opcode == store_op) ? ra : rb;
	assign reg_addr2 = (opcode == store_r_op) ? ra : rc;
	assign reg_addr_in = (opcode == bl_op) ? lr : ra;
	
endmodule
