`timescale 1ns / 1ps


module Fa(a, b, ci, s, co);
input a,b,ci;
output co, s;
assign s = (a^b)^ci;
assign co = (a&b)|(b&ci)|(ci&a);
 
endmodule
