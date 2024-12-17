`define TimeExpire1 32'd25000000 
`define TimeExpire2 32'd2500

module Traffic_Light(clock, reset, dot_row, dot_col, out);

	input clock, reset;
	output [7:0] dot_row;
	output [7:0] dot_col;
	output [6:0] out;
	wire clk_div1, clk_div2;
	wire [3:0] count;
	wire [1:0] gyr;

	Frequency_Divider1 u_FreqDiv1(.clk(clock), .rst(reset), .clk_div(clk_div1));
	Frequency_Divider2 u_FreqDiv2(.clk(clock), .rst(reset), .clk_div(clk_div2));
	Counter u_Counter(.clk(clk_div1), .rst(reset), .count(count), .gyr(gyr));
	SevenDisplay u_SevenDisplay(.count(count), .out(out));
	DotMatrixDisplay u_DotMatrixDisplay(.clk(clk_div2), .gyr(gyr), .rst(reset), .dot_row(dot_row), .dot_col(dot_col));
	
endmodule 

module DotMatrixDisplay(clk, gyr, rst, dot_row, dot_col);

	input clk, rst;
	input [1:0] gyr;
	output reg [7:0] dot_row;
	output reg [7:0] dot_col;
	reg [2:0] row_count;
	
	always @(posedge clk or negedge rst) begin
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
			if(gyr == 0) begin
				case(row_count)
					3'd0: dot_col <= 8'b00001100;
					3'd1: dot_col <= 8'b00001100;
					3'd2: dot_col <= 8'b00011001;
					3'd3: dot_col <= 8'b01111110;
					3'd4: dot_col <= 8'b10011000;
					3'd5: dot_col <= 8'b00011000;
					3'd6: dot_col <= 8'b00101000;
					3'd7: dot_col <= 8'b01001000;
				endcase
			end else if(gyr == 1) begin
				case(row_count)
					3'd0: dot_col <= 8'b00000000;
					3'd1: dot_col <= 8'b00100100;
					3'd2: dot_col <= 8'b00111100;
					3'd3: dot_col <= 8'b10111101;
					3'd4: dot_col <= 8'b11111111;
					3'd5: dot_col <= 8'b00111100;
					3'd6: dot_col <= 8'b00111100;
					3'd7: dot_col <= 8'b00000000;
				endcase
			end else if(gyr == 2) begin
				case(row_count)
					3'd0: dot_col <= 8'b00011000;
					3'd1: dot_col <= 8'b00011000;
					3'd2: dot_col <= 8'b00111100;
					3'd3: dot_col <= 8'b00111100;
					3'd4: dot_col <= 8'b01011010;
					3'd5: dot_col <= 8'b00011000;
					3'd6: dot_col <= 8'b00011000;
					3'd7: dot_col <= 8'b00100100;
				endcase
			end
		end
	end
	
endmodule 

module SevenDisplay(count, out);

	input [3:0] count;
	output reg [6:0] out;
	
	always @(count) begin
		case(count)
			4'd0: out <= 7'b1000000;
			4'd1: out <= 7'b1111001;
			4'd2: out <= 7'b0100100;
			4'd3: out <= 7'b0110000;
			4'd4: out <= 7'b0011001;
			4'd5: out <= 7'b0010010;
			4'd6: out <= 7'b0000010;
			4'd7: out <= 7'b1111000;
			4'd8: out <= 7'b0000000;
			4'd9: out <= 7'b0010000;
			4'd10: out <= 7'b0001000;
			4'd11: out <= 7'b0000011;
			4'd12: out <= 7'b1000110;
			4'd13: out <= 7'b0100001;
			4'd14: out <= 7'b0000110;
			4'd15: out <= 7'b0001110;
			default: out <= 7'b1000000;
		endcase
	end
	
endmodule 

module Counter(clk, rst, count, gyr);

	input clk, rst;
	output reg [3:0] count;
	output reg [1:0] gyr;
	
	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			count <= 10;
			gyr <= 0;
		end else if(count != 0) begin
			count <= count - 1;
		end else begin
			if(gyr == 0) begin
				count <= 3;
				gyr <= 1;
			end else if(gyr == 1) begin
				count <= 15;
				gyr <= 2;
			end else if(gyr == 2) begin
				count <= 10;
				gyr <= 0;
			end 
		end
	end
	
endmodule 

module Frequency_Divider1(clk, rst, clk_div);

	input clk, rst;
	output reg clk_div;
	reg [31:0] count;
	
	always @(posedge clk) begin
		if(!rst) begin
			count <= 32'd0;
			clk_div <= 1'b0;
		end else begin
			if(count == `TimeExpire1) begin
				count <= 32'd0;
				clk_div <= ~clk_div;
			end else begin
				count <= count + 32'd1;
			end
		end
	end
	
endmodule 

module Frequency_Divider2(clk, rst, clk_div);

	input clk, rst;
	output reg clk_div;
	reg [31:0] count;
	
	always @(posedge clk) begin
		if(!rst) begin
			count <= 32'd0;
			clk_div <= 1'b0;
		end else begin
			if(count == `TimeExpire2) begin
				count <= 32'd0;
				clk_div <= ~clk_div;
			end else begin
				count <= count + 32'd1;
			end
		end
	end
	
endmodule 