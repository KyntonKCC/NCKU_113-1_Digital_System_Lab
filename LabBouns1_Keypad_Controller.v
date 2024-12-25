`define TimeExpire 32'd2500
`define TimeExpire_KEY 32'd250000

module Keypad_Controller(clock, reset, keypadCol, keypadRow, dot_row, dot_col);
    
	input clock, reset; 
	input [3:0] keypadCol; 
	output [3:0] keypadRow; 
	output [7:0] dot_row;
	output [7:0] dot_col;
	wire clk_div;
	wire [3:0] keypad_buffer;

	Frequency_Divider u_FreqDiv(
		.clk(clock), 
		.rst(reset), 
		.clk_div(clk_div)
	);

	checkkeypad u_checkkeypad(
		.clk(clock), 
		.rst(reset), 
		.keypadCol(keypadCol), 
		.keypadRow(keypadRow), 
		.keypadBuf(keypad_buffer)
	);

	Matrix_Controller u_MatrCont(
		.clk_div(clk_div), 
		.rst(reset), 
		.dot_row(dot_row), 
		.dot_col(dot_col), 
		.keypadBuf(keypad_buffer)
	);

endmodule 

module checkkeypad(clk, rst, keypadCol, keypadRow, keypadBuf);

	input clk, rst;
	input [3:0] keypadCol; 
	output reg [3:0] keypadRow;
	output reg [3:0] keypadBuf;
	reg [31:0] keypadDelay;

	always @(posedge clk) begin
		if (!rst) begin
			keypadRow <= 4'b1110;
			keypadBuf <= 4'b0000;
			keypadDelay <= 31'd0;
		end else begin
			if (keypadDelay == `TimeExpire_KEY) begin
				keypadDelay <= 31'd0;
					case ({keypadRow, keypadCol})
						8'b1110_1110 : keypadBuf <= 4'h7;
						8'b1110_1101 : keypadBuf <= 4'h4; 
						8'b1110_1011 : keypadBuf <= 4'h1; 
						8'b1110_0111 : keypadBuf <= 4'h0; 
						8'b1101_1110 : keypadBuf <= 4'h8; 
						8'b1101_1101 : keypadBuf <= 4'h5; 
						8'b1101_1011 : keypadBuf <= 4'h2; 
						8'b1101_0111 : keypadBuf <= 4'ha; 
						8'b1011_1110 : keypadBuf <= 4'h9; 
						8'b1011_1101 : keypadBuf <= 4'h6; 
						8'b1011_1011 : keypadBuf <= 4'h3; 
						8'b1011_0111 : keypadBuf <= 4'hb; 
						8'b0111_1110 : keypadBuf <= 4'hc; 
						8'b0111_1101 : keypadBuf <= 4'hd; 
						8'b0111_1011 : keypadBuf <= 4'he; 
						8'b0111_0111 : keypadBuf <= 4'hf;   
						default : keypadBuf <= keypadBuf;
					endcase
					case (keypadRow)
						4'b1110 : keypadRow <= 4'b1101;
						4'b1101 : keypadRow <= 4'b1011; 
						4'b1011 : keypadRow <= 4'b0111; 
						4'b0111 : keypadRow <= 4'b1110;  
						default : keypadRow <= 4'b1110;
					endcase
				end else begin
					keypadDelay <= keypadDelay + 1'b1;
            end
        end
    end

endmodule 


module Matrix_Controller(clk_div, rst, keypadBuf, dot_row, dot_col);

	input clk_div, rst;
	input [3:0] keypadBuf;
	output reg [7:0] dot_row;
	output reg [7:0] dot_col;
	reg [2:0] row_count;

	always @(posedge clk_div or negedge rst) begin
		if (!rst) begin
			dot_row <= 8'b0;
			dot_col <= 8'b0;
			row_count <= 3'd0;
		end else begin
			row_count <= row_count + 1;
			case(row_count)
				0: dot_row <= 8'b01111111;
				1: dot_row <= 8'b10111111;
				2: dot_row <= 8'b11011111;
				3: dot_row <= 8'b11101111;
				4: dot_row <= 8'b11110111;
				5: dot_row <= 8'b11111011;
				6: dot_row <= 8'b11111101;
				7: dot_row <= 8'b11111110;
			endcase
			case (keypadBuf)
				4'h7: dot_col <= (row_count == 6 || row_count == 7) ? 8'b00000011 : 8'b00000000;
				4'h4: dot_col <= (row_count == 6 || row_count == 7) ? 8'b00001100 : 8'b00000000;
				4'h1: dot_col <= (row_count == 6 || row_count == 7) ? 8'b00110000 : 8'b00000000;
				4'h0: dot_col <= (row_count == 6 || row_count == 7) ? 8'b11000000 : 8'b00000000;
				4'h8: dot_col <= (row_count == 4 || row_count == 5) ? 8'b00000011 : 8'b00000000;
				4'h5: dot_col <= (row_count == 4 || row_count == 5) ? 8'b00001100 : 8'b00000000;
				4'h2: dot_col <= (row_count == 4 || row_count == 5) ? 8'b00110000 : 8'b00000000;
				4'ha: dot_col <= (row_count == 4 || row_count == 5) ? 8'b11000000 : 8'b00000000;
				4'h9: dot_col <= (row_count == 2 || row_count == 3) ? 8'b00000011 : 8'b00000000;
				4'h6: dot_col <= (row_count == 2 || row_count == 3) ? 8'b00001100 : 8'b00000000;
				4'h3: dot_col <= (row_count == 2 || row_count == 3) ? 8'b00110000 : 8'b00000000;
				4'hb: dot_col <= (row_count == 2 || row_count == 3) ? 8'b11000000 : 8'b00000000;
				4'hc: dot_col <= (row_count == 0 || row_count == 1) ? 8'b00000011 : 8'b00000000;
				4'hd: dot_col <= (row_count == 0 || row_count == 1) ? 8'b00001100 : 8'b00000000;
				4'he: dot_col <= (row_count == 0 || row_count == 1) ? 8'b00110000 : 8'b00000000;
				4'hf: dot_col <= (row_count == 0 || row_count == 1) ? 8'b11000000 : 8'b00000000;
				default: dot_col <= 8'b00000000;
			endcase
		end
	end

endmodule 


module Frequency_Divider(clk, rst, clk_div);

	input clk, rst;
	output reg clk_div;
	reg [31:0] count;

	always @(posedge clk) begin
		if (!rst) begin
			count <= 32'd0;
			clk_div <= 1'b0;
		end else begin
			if (count == `TimeExpire) begin
				count <= 32'd0;
				clk_div <= ~clk_div;
			end else begin
				count <= count + 32'd1;
			end
		end
	end
	
endmodule 