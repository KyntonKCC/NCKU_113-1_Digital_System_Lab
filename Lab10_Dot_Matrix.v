`define TimeExpire 32'd2500
module Dot_Matrix(clock, reset, dot_row, dot_col);
	
	input clock, reset;
	output [7:0] dot_row;
	output [7:0] dot_col;
	wire clk_div;
	
	Frequency_Divider u_FreqDiv(.clk(clock), .rst(reset), .clk_div(clk_div));
	Matrix_Controller u_MatrCont(.clk_div(clk_div), .rst(reset), .dot_row(dot_row), .dot_col(dot_col));
	
endmodule 

module Matrix_Controller(clk_div, rst, dot_row, dot_col);

	input clk_div, rst;
	output reg [7:0] dot_row;
	output reg [7:0] dot_col;
	reg [2:0] row_count;
	
	always @(posedge clk_div or negedge rst)
	begin
		if(~rst) begin
			dot_row <= 8'b0;
			dot_col <= 8'b0;
			row_count <= 0;
		end else begin
			row_count <= row_count + 1;
			case(row_count)
				3'd0: dot_row <= 8'b01111111;
				3'd1: dot_row <= 8'b10111111;
				3'd2: dot_row <= 8'b11011111;
				3'd3: dot_row <= 8'b11101111;
				3'd4: dot_row <= 8'b11110111;
				3'd5: dot_row <= 8'b11111011;
				3'd6: dot_row <= 8'b11111101;
				3'd7: dot_row <= 8'b11111110;
			endcase
			case(row_count)
				3'd0: dot_col <= 8'b00011000;
				3'd1: dot_col <= 8'b00100100;
				3'd2: dot_col <= 8'b01000010;
				3'd3: dot_col <= 8'b11000011;
				3'd4: dot_col <= 8'b01000010;
				3'd5: dot_col <= 8'b01000010;
				3'd6: dot_col <= 8'b01000010;
				3'd7: dot_col <= 8'b01111110;
			endcase
		end
	end

endmodule 

module Frequency_Divider(clk, rst, clk_div);

	input clk, rst;
	output reg clk_div;
	reg [31:0] count;
	
	always@(posedge clk)
	begin
		if(!rst) begin
			count <= 32'd0;
			clk_div <= 1'b0;
		end else begin
			if(count == `TimeExpire) begin
				count <= 32'd0;
				clk_div <= ~clk_div;
			end else begin
				count <= count + 32'd1;
			end
		end
	end
	
endmodule 