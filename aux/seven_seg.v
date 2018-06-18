module seven_seg(clk, seg, dig, data);
	output reg [7:0] seg;
	output reg [3:0] dig;
	input [15:0] data;
	input clk;
	
	reg [1:0] dig_select = 0;
	
	always@(posedge clk) begin
		dig_select = dig_select + 1;
	end
	
	always@(posedge clk) begin
		case (dig_select)
			2'd0: dig = 4'b1110;
			2'd1: dig = 4'b1101;
			2'd2: dig = 4'b1011;
			2'd3: dig = 4'b0111;
		endcase
	end
	
	reg [3:0] curr_dig;
	always@(posedge clk) begin
		case (dig_select)
			2'd0: curr_dig = data[3:0];
			2'd1: curr_dig = data[7:4];
			2'd2: curr_dig = data[11:8];
			2'd3: curr_dig = data[15:12];
		endcase
		case (curr_dig)
			4'h0: seg = 8'hc0;
			4'h1: seg = 8'hf9;
			4'h2: seg = 8'ha4;
			4'h3: seg = 8'hb0;
			4'h4: seg = 8'h99;
			4'h5: seg = 8'h92;
			4'h6: seg = 8'h82;
			4'h7: seg = 8'hf8;
			4'h8: seg = 8'h80;
			4'h9: seg = 8'h90;
			4'ha: seg = 8'h88;
			4'hb: seg = 8'h83;
			4'hc: seg = 8'hc6;
			4'hd: seg = 8'ha1;
			4'he: seg = 8'h86;
			4'hf: seg = 8'h8e;
		endcase
	end
endmodule
