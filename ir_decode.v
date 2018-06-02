module ir_decode(instruction_reg, reg_addr2, reg_addr1, reg_addr_in,
					  imm1, imm2, imm3, alu_op, opcode);
	`include "parameters.v"
	
	input [WORD_SIZE-1:0] instruction_reg;
	output [REG_ADDR_SIZE-1:0] reg_addr1, reg_addr_in;
	output reg [REG_ADDR_SIZE-1:0] reg_addr2;
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
	
	
	assign alu_op = (opcode == load_r || opcode == store_r) ? 3'b000 : opcode[2:0];
	
//	Link register addr
	parameter lr = 3'b111;
	
	assign reg_addr1 = (opcode == br || opcode == store || opcode == cmp || opcode == cmpi) ? ra : rb;
	
	always@(*) begin
		if(opcode == store_r) reg_addr2 = ra;
		else if(opcode == cmp) reg_addr2 = rb;
		else reg_addr2 = rc;
	end
	
	assign reg_addr_in = (opcode == bl) ? lr : ra;
	
endmodule
