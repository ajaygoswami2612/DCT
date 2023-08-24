`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IITG
// Engineer: RACHIT SINGH
// 
// Create Date: 24.01.2023 09:29:57
// Design Name: 
// Module Name: Adder_Subtractor
// Project Name: DSP_project
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Adder_Subtractor#(parameter N = 23, M = 8)(a,b,s);
input [N+M:0] a,b;
output  [N+M:0] s;
wire [N:0] aa,bb;
wire [($clog2(N))-1:0] count ;
wire aeq,bgrt, add, expeq, aexpgrt;
wire [M-1:0] shift;
wire [N:0] c;
wire [N+1:0] d;
wire [M-1:0]expotential;


  assign aa[N-1:0] = a[N-1:0];
  assign bb[N-1:0] = b[N-1:0];
  assign aa[N] = (|a)? 1'b1:1'b0;
  assign bb[N] = (|b)? 1'b1:1'b0;
    
  

  assign aexpgrt = (a[N+M-1:N]>b[N+M-1:N])? 1:0;
  assign expeq = (a[N+M-1:N] == b[N+M-1:N])? 1:0;
  assign aeq = ((expeq)&&(aa==bb))? 1:0;
  assign bgrt = (b[30:23]>a[30:23])? 1: (aexpgrt)? 0: (b[23:0]> a[23:0])? 1:0;
  assign add = (a[N+M] == b[N+M])? 1:0;
  
  assign s[N+M] = (add)? a[N+M]: (bgrt)? b[31]:a[N+M];  
  
  assign expotential[M-1:0] = aexpgrt? a[N+M-1:N]:b[N+M-1:N];
  
 assign shift = aexpgrt? (a[N+M-1:N] - b[N+M-1:N]):(b[N+M-1:N] - a[N+M-1:N]);
 assign c = bgrt? (aa >> shift): (bb >> shift);
 assign d[N+1:0] = add? (c + ((bgrt)? bb:aa)): (bgrt)? (bb - c) : (aa - c) ;
 wire zero_result = ~(|d);
 priority_encoder #(N)encoder(d[N:0],count);
 
  
  
  assign s[N-1:0] = add? (d[N+1]? (d[N:0] >> 1): d[N-1:0]):(d[N-1:0]<<count); 
  assign s[N+M-1:N] = zero_result? 0: (add? (d[N+1]? (expotential[M-1:0]+1):(expotential[M-1:0])):( expotential[M-1:0]-count));


endmodule