`timescale 1ns / 1ps

module priority_encoder#(parameter L = 23)( x,y);
input [L:0] x;
output [($clog2(L))-1:0]y;
wire [($clog2(L))-1:0]count[L+1:0];
assign count[0] = 0;
genvar i;
  for(i=0;i<L+1;i = i+1)
  begin
  assign count[i+1] = (x[i] == 1'b1)?(L-i):count[i];
  end
  assign y = count[L+1];
endmodule