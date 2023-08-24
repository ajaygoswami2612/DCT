`timescale 1ns / 1ps
//tested
module addsub#(parameter M = 23, E = 8)(x1, y1, x2, y2);
input [M+E:0]x1, y1;
output  [M+E:0] x2, y2;
wire [M+E:0]w;
Adder_Subtractor plus(x1, y1, x2);
assign w[M+E] = ~y1[M+E];
assign w[0+:M+E] = y1[0+:M+E];
Adder_Subtractor minus(x1, w, y2);
endmodule
