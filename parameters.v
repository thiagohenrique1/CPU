//	Opcodes

//	Type 2
	parameter cmp = 5'b11000;
	parameter load_r = 5'b11001;
	parameter store_r = 5'b11010;
	parameter br = 5'b11011;

//	Type 3
	parameter cmpi = 5'b11100;
	parameter load = 5'b11101;
	parameter store = 5'b11110;
	parameter load_i = 5'b11111;

//	Type 4
	parameter b = 5'b10000;
	parameter beq = 5'b10001;
	parameter bne = 5'b10010;
	parameter bhe = 5'b10011;
	parameter bst = 5'b10100;
	parameter bleq = 5'b10101;
	parameter blne = 5'b10110;
	parameter bl = 5'b10111;

//	Other parameters
	parameter WORD_SIZE = 16, ALU_OP_SIZE = 3, REG_ADDR_SIZE = 3;
