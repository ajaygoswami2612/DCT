`timescale 1ns / 1ps
//tested - 1bug fixed
module RightShift#(parameter M = 23, E = 8, I = 8)(a, b, c);
input [M+E:0]a;                //I refer to maximum no. of iterations, cordic has to perform
input [$clog2(I)-1:0] b;       //amount of right shift
output [M+E:0]c;
assign c[0+:M] = a[0+:M];      //mantissa
assign c[M+:E] = (a[M+:E] == 0)? 0 : a[M+:E] - b;  //exponent
assign c[M+E] = a[M+E];        //sign
endmodule       
