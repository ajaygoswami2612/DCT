`timescale 1ns / 1ps
//tested
//when reset is high or enable is low, it will give f as output
//i.e, it will count first clock cycle as '0'
//if you want otherwise, just change the value of out in line 9 and 18

module Counter#(parameter K = 6)(clk, en, reset, out);
input clk, reset, en;
output reg [K-1:0] out = 0;
always @(posedge clk)
 begin
  if(en&&(!reset))
   begin
    out <= out + 1;
   end
  else
   begin
    out <= 0;
   end
 end
endmodule

