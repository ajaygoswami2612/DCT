`timescale 1ns / 1ps

//pure combinational
module Datapath#(parameter M = 23, E = 8, I = 11, DCT_POINT = 16 )(inp1, ang, sequencer, outp, clk, clr);
input [((M+E+1)*(DCT_POINT/2))-1:0] inp1; // 32*8--8inputs
input [((M+E+1)*(DCT_POINT/4))-1:0]ang;
input clk, clr;
input [(2*(DCT_POINT/4))-1:0] sequencer;
output  [M+E:0] outp;

wire [M+E:0]a[((DCT_POINT/2))-2:0];
wire [M+E:0]X[(DCT_POINT/4)-1:0];
wire [M+E:0]Y[(DCT_POINT/4)-1:0];
wire [M+E:0]d[(DCT_POINT/4)-1:0];

genvar i;

for(i=0; i< (DCT_POINT/4); i = i+1)
 begin
  Cordic_hardware #(.M(M), .E(E), .I(I))stack1(.x1(inp1[((M+E+1)*i)+:(M+E+1)]), .y1(inp1[((M+E+1)*((DCT_POINT/2)-i-1))+:(M+E+1)]), .clk(clk),
  .clr(clr), .angle(ang[((M+E+1)*i)+:(M+E+1)]), .x2(X[i]), .y2(Y[i]));
 end

for(i=0; i< (DCT_POINT/4); i = i+1)
 begin
  assign d[i] = (sequencer[2*i]^sequencer[(2*i)+1])? X[i]:Y[i];
 end

for(i=0; i< (DCT_POINT/4); i = i+1)
 begin
  assign a[i][M+E] = (sequencer[(2*i)+1])? ~d[i][M+E]:d[i][M+E];
  assign a[i][0+:M+E] = d[i][0+:M+E];
 end

for( i=0; i < (DCT_POINT/4)-1; i = i+1)
 begin
  Adder_Subtractor #(.N(M), .M(E))ads1(.a(a[2*i]), .b(a[(2*i)+1]), .s(a[i+(DCT_POINT/4)]));
 end

assign outp = a[(DCT_POINT/2)-2];

endmodule
