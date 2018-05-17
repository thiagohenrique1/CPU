//	Type 1
	parameter cmp_op = 5'b01000; // also (opcode[4:3] == 00)
// Type 3
	parameter br_op = 5'b11111, load_op = 5'b11100, 
			  store_op = 5'b11101, load_i_op = 5'b11110; 
//	Type 2
	parameter load_r_op = 5'b11000, store_r_op = 5'b11001;
//	Type 4
	parameter b_op = 5'b10000, beq_op = 5'b10001, 
			  bl_op = 5'b10100, ret_op = 5'b10101; 
