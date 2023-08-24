`timescale 1ns / 1ps
//tested -1bug fixed
module cordic#(parameter I = 12, M = 23, E = 8)(x1, y1, position, theta, alpha, x2, y2,
               theta2, clk, clr);
input  [M+E:0] x1, y1, theta, alpha;
input clk, clr;
input [$clog2(I)-1:0] position;
output reg [M+E:0] x2 = 0, y2 = 0, theta2 = 0;

wire [M+E:0] w1, w2, Y1, X1, alph;

RightShift #(.M(M), .E(E), .I(I))shift1(y1, position, w1);
RightShift #(.M(M), .E(E), .I(I))shift2(x1, position, w2);

 assign Y1[M+E] = theta[M+E]? w1[M+E]:(~w1[M+E]);
 assign Y1[0+:M+E] = w1[0+:M+E];
 
 assign X1[M+E] =  theta[M+E]? (~w2[M+E]):w2[M+E];
 assign X1[0+:M+E] = w2[0+:M+E];
 
 assign alph[M+E] =  ~theta[M+E];
 assign alph[0+:M+E] = alpha[0+:M+E];
 
wire [M+E:0] X2, Y2, Theta2;
Adder_Subtractor #(.N(M), .M(E))as1(.a(x1), .b(Y1), .s(X2));
Adder_Subtractor #(.N(M), .M(E))as2(.a(y1), .b(X1), .s(Y2));
Adder_Subtractor #(.N(M), .M(E))as3(.a(theta), .b(alph), .s(Theta2));

always @(posedge clk)
 begin
   if(clr)
    begin
     x2 <= 0;
     y2 <= 0;
     theta2 <= 0;
    end
   else
    begin
     x2 <= X2;
     y2 <= Y2;
     theta2 <= Theta2;
    end
 end
 
endmodule



