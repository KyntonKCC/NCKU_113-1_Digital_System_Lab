`define TimeExpire 32'd6250000
module MidExam(clock, reset, out);

	input clock, reset;
	output [6:0] out;
	wire clock_div;
	wire [3:0] count;
	
	Frequency_Divider u_FreqDiv(.clk(clock), .rst(reset), .clk_div(clock_div));
	Counter u_counter(.clk(clock_div), .rst(reset), .count(count));
	SevenDisplay u_display(.in(count), .out(out));

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

module Counter(clk, rst, count);
	
	input clk, rst;
	output reg [3:0] count;
	
	always@(posedge clk or negedge rst)
	begin
		if(rst == 0) begin
			count = 0;
		end else begin
			if(count == 0) begin
				count = count + 11;
			end else if(count == 11) begin
				count = count - 2;
			end else if(count == 9) begin
				count = count - 3;
			end else if(count == 6) begin
				count = count - 5;
			end else if(count == 1) begin
				count = count + 7;
			end else if(count == 8) begin
				count = count - 6;
			end else if(count == 2) begin
				count = count + 5;
			end else if(count == 7) begin
				count = count - 7;
			end
		end
	end
	
endmodule

module SevenDisplay(in, out);

	input [3:0] in;
	output reg [6:0] out;

	always@(*)
	begin
		case(in)
			4'd0: out = 7'b1000000;
			4'd1: out = 7'b1111001;
			4'd2: out = 7'b0100100;
			4'd3: out = 7'b0110000;
			4'd4: out = 7'b0011001;
			4'd5: out = 7'b0010010;
			4'd6: out = 7'b0000010;
			4'd7: out = 7'b1111000;
			4'd8: out = 7'b0000000;
			4'd9: out = 7'b0010000;
			4'd10: out = 7'b0001000;
			4'd11: out = 7'b0000011;
			4'd12: out = 7'b1000110;
			4'd13: out = 7'b0100001;
			4'd14: out = 7'b0000110;
			4'd15: out = 7'b0001110;
			default: out = 7'b1000000;
		endcase
	end

endmodule 