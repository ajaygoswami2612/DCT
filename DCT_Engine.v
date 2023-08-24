`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2023 01:28:55
// Design Name: 
// Module Name: DCT_Engine
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
//shell

module DCT_Engine#(parameter DCT_POINT = 16, K = 6, M = 23, E = 8, I = 11)(clk, en, reset, inp, out);
input clk, en, reset;
input [M+E:0]inp;
output [M+E:0] out;
wire [((M+E+1)*DCT_POINT)-1:0]Arr;
wire [K-1:0] tally;
wire [((M+E+1)*DCT_POINT)-1:0] cache;
wire clr, start_mem, count_en, msps_en, msps_f, out_en, out_f, cord_F, cord_en;
wire [((M+E+1)*DCT_POINT) - 1:0] temp_out;

Counter #(.K(K))counter1(.clk(clk), .en(count_en), .reset(reset), .out(tally));

controlpath #(.CLOCK_LIM(K), .DCT_POINT(DCT_POINT))controller(.clk(clk), .enable(en), .reset(reset), .clr(clr), 
        .start_mem(start_mem), .tally(tally), .count_en(count_en), .msps_en(msps_en), .msps_f(msps_f), .out_en(out_en)
         , .out_f(out_f), .cord_en(cord_en), .cord_F(cord_F));

memory #(.N(M), .M(E), .K(DCT_POINT))Memory(.reset_mem(clr), .clk(clk), 
      .start_mem(start_mem), .inp(inp), .Arr(Arr));
  
msps #(.DCT_POINT(DCT_POINT), .M(M), .E(E))MSPS(.msps_en(msps_en), .inp(Arr), .clk(clk), .clr(clr), .msps_f(msps_f),
       .cache(cache));
       
cordic_controller #(.M(M), .E(E), .I(I), .DCT_POINT(DCT_POINT))CORDIC(.inp(cache), .clk(clk), .clr(clr), .en(cord_en), .outp(temp_out), .F(cord_F));

outbuffer #(.M(M), .E(E), .arrsize(DCT_POINT))otbf(.inp(temp_out), .outp(out), .clk(clk), 
             .out_en(out_en), .out_f(out_f));

endmodule
