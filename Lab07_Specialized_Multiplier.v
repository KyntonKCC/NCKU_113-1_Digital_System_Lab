module Specialized_Multiplier(IN, OUT);

input [3:0] IN;
output reg [6:0] OUT;

always@(*)
begin
	if(IN <= 2) begin
		OUT = IN;
	end else if(IN <= 5) begin
		OUT = IN * 2 + 1;
	end else if(IN <= 8) begin
		OUT = IN * 2 - 1;
	end else begin
		OUT = 0;
	end 
	
	if(OUT == 0) begin //0
		OUT = 7'b1000000;
	end else if(OUT == 1) begin //1
		OUT = 7'b1111001;
	end else if(OUT == 2) begin //2
		OUT = 7'b0100100;
	end else if(OUT == 3) begin //3
		OUT = 7'b0110000;
	end else if(OUT == 4) begin //4
		OUT = 7'b0011001;
	end else if(OUT == 5) begin //5
		OUT = 7'b0010010;
	end else if(OUT == 6) begin //6
		OUT = 7'b0000010;
	end else if(OUT == 7) begin //7
		OUT = 7'b1111000;
	end else if(OUT == 8) begin //8
		OUT = 7'b0000000;
	end else if(OUT == 9) begin //9
		OUT = 7'b0010000;
	end else if(OUT == 10) begin //a
		OUT = 7'b0001000;
	end else if(OUT == 11) begin //b
		OUT = 7'b0000011;
	end else if(OUT == 12) begin //c
		OUT = 7'b0000110;
	end else if(OUT == 13) begin //d
		OUT = 7'b0100001;
	end else if(OUT == 14) begin //e
		OUT = 7'b0000110;
	end else if(OUT == 15) begin //f
		OUT = 7'b0001110;
	end else begin //0
		OUT = 7'b1000000;
	end 
	
end
	
endmodule 