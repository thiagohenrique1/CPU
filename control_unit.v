module control_unit(clk, reset, ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux,
						  reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write,
						  reg_write, PC_write, IR_write, memory_write, opcode, status_reg);
	`include "parameters.v"
	
//	Inputs
	input clk, reset;
	input [4:0] opcode;
	input [WORD_SIZE-1:0] status_reg;
//	Mux select
	output reg mem_out_mux;
	output reg [1:0] ALU_in2_mux, PC_mux, memory_addr_mux, data_in_mux;
//	Write signals
	output reg reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write;
	output reg reg_write, PC_write, IR_write, memory_write;
	
	parameter fetch = 0, decode = 1, execute = 2, memory_access = 3, write_back = 4, reset_st = 5;
	reg [2:0] stage;
	
	always @(*) begin
		disable_write_signals;
		zero_muxes;
		case(stage)
			fetch: begin
				memory_addr_mux = 0;
				IR_write = 1;
				PC_mux = 0;
				PC_write = 1;
			end
			decode: begin
				reg_buff1_write = (alu_op(opcode) || type(opcode) == 2 ||
										 opcode == store ||  opcode == store_r ||
										 opcode == load_r || cmp_op(opcode));
				reg_buff2_write = (type(opcode) == 1 || opcode == cmp ||
										 opcode == store_r || opcode == cmp);
			end
			execute: begin
				if((type(opcode) == 1 || opcode == cmp)) ALU_in2_mux = 0;
				else if(opcode == cmpi) ALU_in2_mux = 2;
				else ALU_in2_mux = 1;
				ALU_out_write = 1;
				if(opcode != load_r && opcode != store_r) status_reg_write = 1;
			end
			memory_access: begin
				if(opcode == load || opcode == load_r) begin
					if(opcode == load) memory_addr_mux = 2;
					else memory_addr_mux = 3;
					data_in_mux = 1;
					reg_write = 1;
				end
				if(opcode == store || opcode == store_r) begin
					if(opcode == store) memory_addr_mux = 2;
					else memory_addr_mux = 3;
					mem_out_mux = (opcode == store);
					memory_write = 1;
				end
			end
			write_back: begin
				if(write_reg_file(opcode)) begin
					if(opcode == load_i) data_in_mux = 2;
					else if(opcode == bl) data_in_mux = 3;
					else if(alu_op(opcode)) data_in_mux = 0;
					reg_write = 1;
				end
				if(type(opcode) == 4 || opcode == br) begin
					if(opcode == br) PC_mux = 2;
					else PC_mux = 1;
					PC_write = 1;
				end
			end
			reset_st: begin
				PC_mux = 3;
				PC_write = 1;
			end
		endcase
	end
	
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			stage <= reset_st;
		end else
		case(stage)
			fetch: stage <= decode;
			
			decode:
				if(opcode == load_i || opcode == br || (type(opcode) == 4 &&	
						~cancel_branch(opcode, status_reg[1:0])))
					stage <= write_back;
				else if(cancel_branch(opcode, status_reg[1:0]))
					stage <= fetch;
				else if(opcode == load || opcode == store)
					stage <= memory_access;
				else
					stage <= execute;
			
			execute:
				if(cmp_op(opcode))
					stage <= fetch;
				else if(opcode == load_r || opcode == store_r)
					stage <= memory_access;
				else
					stage <= write_back;

			memory_access: stage <= fetch;
			write_back: stage <= fetch;
			reset_st: stage <= fetch;
		endcase
	end
	
	task disable_write_signals;
		{reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write, 
			reg_write, PC_write, IR_write, memory_write} = 0;
	endtask
	
	task zero_muxes;
		{ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux} = 0;
	endtask
	
	function [2:0] type;
		input [4:0] op;
		if(op[4:3] == 2'b00) type = 1;
		else if(op[4:2] == 3'b110 || op[4:3] == 2'b01) type = 2;
		else if(op[4:2] == 3'b111) type = 3;
		else if(op[4:3] == 2'b10) type = 4;
		else type = 0;
	endfunction
	
	function alu_op;
		input [4:0] op;
		alu_op = ~op[4];
	endfunction
	
	function write_reg_file;
		input [4:0] op;
		write_reg_file = (op == load_i || op == bl || alu_op(op));
	endfunction
	
	function cancel_branch;
		input [4:0] op;
		input [1:0] cond;
		cancel_branch = (((op == beq) && ~cond[0]) || ((op == bne) && cond[0])
							||((op == bleq) && ~cond[0]) || ((op == blne) && cond[0])
							||((op == bhe) && ~cond[1]) || ((op == bst) && cond[1]));
	endfunction
	
	function cmp_op;
		input [4:0] op;
		cmp_op = (op == cmp || op == cmpi);
	endfunction
	
	function load_op;
		input [4:0] op;
		load_op = (op == load || op == load_r);
	endfunction
	
	function store_op;
		input [4:0] op;
		store_op = (op == store || op == store_r);
	endfunction
	
	initial stage = fetch;
endmodule
