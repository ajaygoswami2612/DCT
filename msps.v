`timescale 1ns / 1ps
//verified

module msps#(parameter M = 23, E = 8, DCT_POINT = 16)(msps_en, inp, clk, clr, msps_f, cache);

output reg [((M+E+1)*DCT_POINT)-1:0] cache = 0;
input [((M+E+1)*DCT_POINT)-1:0] inp;
reg [M+E:0] inp1, inp2;
input clk, msps_en, clr;           //reset??
wire [M+E:0] X2, Y2;
output reg msps_f;

reg [$clog2(DCT_POINT)-1:0] count = 0;
reg [$clog2(DCT_POINT)-1:0] pointer1 = (DCT_POINT/2);       //reading pointer1 8 
reg [$clog2(DCT_POINT)-1:0] pointer2 = (DCT_POINT/2)-1;   //reading pointer2 7
reg [$clog2(DCT_POINT)-1:0] pointer3 = (DCT_POINT/2)-1;    //writing pointer1  7
reg [$clog2(DCT_POINT)-1:0] pointer4 = (DCT_POINT)-1;    //writing pointer2  15
 
addsub #(.M(M), .E(E))hrdwrblk(.x1(inp1), .y1(inp2), .x2(X2), .y2(Y2));

always @(posedge clk)
 begin
  if(msps_en&&(!clr))
   begin
      if(count == (DCT_POINT/2)-1)
       begin
        count = 0;
        msps_f = 1;
       end
      else
       begin
        msps_f = 0;
        count = count + 1;
        pointer1 = pointer1 + 1;  
        pointer2 = pointer2 - 1;
        pointer3 = pointer3-1;
        pointer4 = pointer4-1;
       end
     end 
    else 
     begin 
      msps_f = 0;
      count = 0;
     end  
   end

 
 always @(posedge clk)
  begin
    inp1 <= inp[((M+E+1)*pointer2)+:(M+E+1)];
    inp2 <= inp[((M+E+1)*pointer1)+:(M+E+1)];
  end
 always @(negedge clk)
  begin
   if(msps_en&&(!msps_f))
    begin
     cache[(M+E+1)*pointer3+:(M+E+1)] <= Y2; //Ms 
     cache[(M+E+1)*pointer4+:(M+E+1)] <= X2; //Ps
    end
  end
 
endmodule
