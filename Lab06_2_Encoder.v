module Encoder(in, out, valid);

input [7:0] in;
output reg [2:0] out;
output reg valid;

always@(*)
begin
	if(in)begin
		valid = 1'b1;
	end else begin
		valid = 1'b0;
	end
	case(in)
		8'b0000_0001: begin out = 3'd0; end
		8'b0000_0010: begin out = 3'd1; end
		8'b0000_0100: begin out = 3'd2; end
		8'b0000_1000: begin out = 3'd3; end
		8'b0001_0000: begin out = 3'd4; end
		8'b0010_0000: begin out = 3'd5; end
		8'b0100_0000: begin out = 3'd6; end
		8'b1000_0000: begin out = 3'd7; end
		default: begin {valid, out} = 4'd0; end
	endcase
end

endmodule 