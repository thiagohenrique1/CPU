module register_file(reg_buff1, reg_buff2, write, addr1, addr2, addr_in,
							data_in, clk, write_buff1, write_buff2);
	
	parameter WORD_SIZE = 16, REG_NUM = 8;
	
	output reg [WORD_SIZE-1:0] reg_buff1,reg_buff2;
	input write, clk, write_buff1, write_buff2;
	input [2:0] addr1, addr2, addr_in;
	input [WORD_SIZE-1:0] data_in;
	
	reg [WORD_SIZE-1:0] reg_file[REG_NUM:0];
	
	always@(posedge clk) begin
		if(write_buff1)
			reg_buff1 = reg_file[addr1];
		if(write_buff2)
			reg_buff2 = reg_file[addr2];
	end
	
	always@(posedge clk) begin
		if(write) reg_file[addr_in] = data_in;
	end
	
endmodule
