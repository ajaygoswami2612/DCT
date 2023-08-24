`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IITG
// Engineer: Rachit Singh
// 
// Create Date: 21.03.2023 21:42:45
// Design Name: Memory
// Module Name: memory
// Project Name: nil.
// Target Devices: Artrix 7
// Tool Versions: Vivado 2019.2
// Description: Generic module for taking K inputs and storing them in memory
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory#(parameter N = 23, M = 8, L = N+M+1, K = 16)(reset_mem, clk,
                                         start_mem, inp, Arr);
input start_mem, clk, reset_mem;
input [L-1:0] inp;
output reg [(L*K)-1:0] Arr;
reg [$clog2(K)-1:0]count = 0;
always @(negedge clk)
  begin 
    if(reset_mem)
      begin
        Arr <= 0;
        count <= 0;
      end
    else
    if(start_mem)
      begin
        Arr[(count*L)+: L] <= inp;
        count <= count + 1;  //it will rolloff on its own
      end
    else count <= 0;
  end
endmodule
