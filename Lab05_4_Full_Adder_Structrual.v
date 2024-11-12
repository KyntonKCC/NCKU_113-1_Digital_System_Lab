module Full_Adder_Structrual(a, b, c_in, sum, c_out);

input a, b, c_in;
output sum, c_out;
wire w1, w2, w3;

Half_Adder_Structrual(.a(a), .b(b), .sum(w1), .c_out(w2));
Half_Adder_Structrual(.a(c_in), .b(w1), .sum(sum), .c_out(w3));
or(c_out, w2, w3);

endmodule 

module Half_Adder_Structrual(a, b, sum, c_out);

input a, b;
output sum, c_out;

xor(sum, a, b);
and(c_out, a, b);

endmodule 