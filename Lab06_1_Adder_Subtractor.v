module Adder_Subtractor(a, b, select, S, C, V);

input [3:0] a;
input [3:0] b;
input select;
output reg [3:0] S;
output reg C, V;


always@(*)
begin
	{V, S} = (select == 1) ? (a - b) : (a + b);
	C = V;
end

endmodule 