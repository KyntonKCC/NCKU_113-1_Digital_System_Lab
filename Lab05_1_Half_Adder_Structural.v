module Half_Adder_Structural(a, b, sum, c_out);

input a, b;
output sum, c_out;

xor(sum, a, b);
and(c_out, a, b);

endmodule 