module control_unit(clk, ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux,
						  reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write,
						  reg_write, PC_write, IR_write, memory_write, opcode, status_reg);
	
	parameter WORD_SIZE = 16, ALU_OP_SIZE = 3, REG_ADDR_SIZE = 3;
	
// Inputs
	input clk;
	input [4:0] opcode;
	input [WORD_SIZE-1:0] status_reg;
//	Mux select
	output reg ALU_in2_mux, mem_out_mux;
	output reg [1:0] PC_mux, memory_addr_mux, data_in_mux;
//	Write signals
	output reg reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write;
	output reg reg_write, PC_write, IR_write, memory_write;
	
	parameter fetch = 0, decode = 1, execute = 2;
	reg [1:0] cycle;
	
	always @(cycle) begin
		disable_write_signals();
		case(cycle)
			fetch: begin
				memory_addr_mux = 0;
				IR_write = 1;
			end
			decode: begin
			end
			execute: begin
			end
		endcase
	end
	
	always @(posedge clk) begin
		case(cycle)
			fetch: cycle <= decode;
			decode: cycle <= execute;
			execute: cycle <= fetch;
		endcase
	end
	
	initial begin
		disable_write_signals();
		zero_muxes();
		cycle = fetch;
	end
	
	task disable_write_signals;
		{reg_buff1_write, reg_buff2_write, status_reg_write, ALU_out_write, 
			reg_write, PC_write, IR_write, memory_write} = 0;
	endtask
	
	task zero_muxes;
		{ALU_in2_mux, mem_out_mux, PC_mux, memory_addr_mux, data_in_mux} = 0;
	endtask
	
endmodule
