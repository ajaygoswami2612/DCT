`timescale 1ns / 1ps

module outbuffer#(parameter M = 23, E = 8, arrsize = 16)(inp, outp, clk, out_en, out_f );
input [(arrsize*(M+E+1))-1:0]inp;
reg [$clog2(arrsize)-1:0] cnt = 0;
input clk, out_en;
output reg [M+E:0] outp;
output reg out_f = 0;


 always @(posedge clk)
  begin
   if(out_en)
    begin
     if(cnt == arrsize-1)
      begin
       out_f <= 1;
       cnt <= 0;
       outp <= 0;
      end 
     else
      begin
       cnt <= cnt + 1;
       out_f <= 0;
      end
    if(!out_f)  outp <= inp[cnt*(M+E+1)+:M+E+1]; 
    else outp <= 0;
    end
   else
    begin
       outp <= 0;
    end  
  end
endmodule
