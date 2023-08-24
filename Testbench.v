`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2023 17:03:05
// Design Name: 
// Module Name: Testbench
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


module Testbench( );
parameter DCT_POINT = 16, K = 6, M = 23, E = 8, timeperiod = 100;
reg clk, en, reset;
reg [M+E:0] inp;
wire [M+E:0] out;
DCT_Engine #(.DCT_POINT(DCT_POINT), .K(K), .M(M), .E(E))dct(.clk(clk), .en(en), .reset(reset)
, .inp(inp), .out(out) );

always #(timeperiod/2) clk = ~clk;

initial
 begin
  clk = 0;
  en = 0;
  reset = 1;
  #timeperiod reset = 0;
  #timeperiod en = 1;
  #(timeperiod/2)
              inp = 32'h41200000;
  #timeperiod inp = 32'h41A00000;
  #timeperiod inp = 32'h00000000;
  #timeperiod inp = 32'hC0A00000;
  #timeperiod inp = 32'h41F00000;
  #timeperiod inp = 32'h41400000;
  #timeperiod inp = 32'h42040000;
  #timeperiod inp = 32'hC0800000;
  #timeperiod inp = 32'h41900000;
  #timeperiod inp = 32'h41400000;
  #timeperiod inp = 32'hC1100000;
  #timeperiod inp = 32'h40000000;
  #timeperiod inp = 32'hC0E00000;
  #timeperiod inp = 32'h41980000;
  #timeperiod inp = 32'h40000000;
  #timeperiod inp = 32'h41A80000;
  #6000 $stop;
  
 end

endmodule
