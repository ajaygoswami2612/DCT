`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2023 19:46:28
// Design Name: 
// Module Name: shifter
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

 //should work :}  //
module shifter#(parameter shift = 5, L = 32)(a,b,clr,clk );
input [L-1:0] a;
output [L-1:0] b;
input clr, clk;
reg [L*(shift + 2)-1:0] register;    //N-k+2 shifter
always @(posedge clk)
 begin
  if(clr)
   begin
    register = 0;
   end
  else
   begin
    register[L*(shift + 2)-1:L*(shift + 1)] = a;
    register = register >> L;
   end 
 end
 assign b = register[L- 1:0];
endmodule