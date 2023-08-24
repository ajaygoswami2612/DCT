`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IITG
// Engineer: Rachit Singh
// 
// Create Date: 20.04.2023 23:36:55
// Design Name: Cordic
// Module Name: Cordic_hardware
// Project Name: Pipelined cordic architecture
// Target Devices: Artrix 7
// Tool Versions: Vivado 2019.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Cordic_hardware#(parameter M = 23, E = 8, I = 11)(x1, y1, clk, clr, angle, x2, y2);
input [M+E:0] x1, y1, angle;
input clk, clr;
output [M+E:0] x2, y2;
wire [M+E:0]alphas[I-1:0];
wire [M+E:0] x[I:0];
wire [M+E:0] y[I:0];
wire [M+E:0] ang[I:0];
wire [M+E:0] X[I:0];
wire [M+E:0] Y[I:0];
wire [$clog2(I)-1:0] pos[I:0];
assign alphas[0] = 32'h42340000; //these values are in 32 bit ieee754 format
assign alphas[1] = 32'h41D4853A; //change these values in case you eant to use some 
assign alphas[2] = 32'h41609474; //other representation. Formula for alpha is
assign alphas[3] = 32'h40E40022; // alpha = taninverse(2**(-K)) where k is the index
assign alphas[4] = 32'h4064E2AA; // of alpha in array
assign alphas[5] = 32'h3FE51BCA;
assign alphas[6] = 32'h3F652A1B;
assign alphas[7] = 32'h3EE52DAF;
assign alphas[8] = 32'h3E652E94;
assign alphas[9] = 32'h3DE52ECE;
assign alphas[10] = 32'h3D652EDC;

genvar i;

assign x[0] = x1;
assign y[0] = y1;
assign ang[0] = angle;
assign pos[0] = 0;

for(i = 0; i < I; i = i+1)
 begin
  cordic #(.M(M), .E(E), .I(I))cordicblock(.x1(x[i]), .y1(y[i]), .position(pos[i]), .theta(ang[i]), 
                        .alpha(alphas[i]), .clk(clk), .clr(clr), .x2(x[i+1]), .y2(y[i+1]), .theta2(ang[i+1]));
  assign pos[i+1] = pos[i] + 1;
 end

assign x2 = x[I]; // These outputs are not multiplied by constant!. To get correct results, scale down
assign y2 = y[I]; //final result by 0.607252959138945 (floating point representation: 3F1B74EE
                  //for 12 iterations. Python code is included to calculate scaling constant
endmodule         // for any number of iterations.


/*
 import math
k = 1
for i in range(12):
    k = k*math.cos(math.atan(2**(-i)))
print(k)
*/
