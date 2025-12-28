module Half_Adder_Behavioral(a, b, sum, c_out);

input a, b;
output reg sum, c_out;

always@(a, b)
begin
	sum = a ^ b;
	c_out = a & b;
end 

endmodule 