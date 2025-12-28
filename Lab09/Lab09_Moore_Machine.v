`define TimeExpire 32'd25000000
module Moore_Machine(clock, reset, In, Out);

	input clock, reset, In;
	output [6:0] Out;
	wire clock_div;
	wire [3:0] tmp;

	Frequency_Divider u_FreqDiv(.clk(clock), .rst(reset), .clk_div(clock_div));
	Counter u_Counter(.clk(clock_div), .rst(reset), .in(In), .tmp(tmp));
	SevenDisplay u_display(.in(tmp), .out(Out));
	
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

module Counter(clk, rst, in, tmp);

	input clk, rst, in;
	output reg [3:0] tmp;
	
	always@(posedge clk or negedge rst)
	begin
		if(rst == 0) begin
			tmp = 0;
		end else begin
			if(in == 0) begin
				if(tmp != 5) begin
					tmp = tmp + 1;
				end else begin
					tmp = tmp - 5;
				end
			end else begin
				if(tmp == 0) begin
					tmp = tmp + 3;
				end else if(tmp == 1) begin
					tmp = tmp + 4;
				end else if(tmp == 2) begin
					tmp = tmp - 2;
				end else if(tmp == 3) begin
					tmp = tmp - 2;
				end else if(tmp == 4) begin
					tmp = tmp - 2;
				end else begin
					tmp = tmp - 1;
				end 
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
			/*
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
			*/
		endcase
	end

endmodule 