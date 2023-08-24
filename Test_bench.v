`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2023 14:11:27
// Design Name: 
// Module Name: Test_bench
// Project Name: 
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


module Test_bench();
parameter M = 23, E = 8, I = 12;
reg [M+E:0]a, b, theta;
reg clk, clr;
wire [M+E:0]c, d;

Cordic_hardware shift(.x1(a), .y1(b), .clk(clk), .clr(clr), .angle(theta), .x2(c), .y2(d));
always #50 clk <= ~clk;

initial
 begin
  clk = 0;
  clr = 1;
  #100 clr = 0;
  a = 32'h41200000;  //10
  b = 32'h41200000;  //10
  theta = 32'h41200000; //10
  #100
  a = 32'h40800000;  //4
  b = 32'h40800000;  //4
  theta = 32'h41F00000; //30
  #100
  a = 32'h40C00000; // 6
  b = 32'h41800000; //16
  theta = 32'h42700000; //60
  #100
  a = 32'h3F800000; //1
  b = 32'h00000000; //0
  theta = 32'h42340000; //45
  #100
  a = 32'h00000000; //0
  b = 32'h3F800000; //1
  theta = 32'h42B40000; //90
  #100
  a = 32'h00000000; //0
  b = 32'h3F800000; //1
  theta = 32'h00000000; //90
  #1400 clr = 1;
  
 end

endmodule
