`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iitg
// Engineer: Rachit Singh
// 
// Create Date: 17.01.2023 09:43:37
// Design Name: 
// Module Name: fmshell
// Project Name: multiplier
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


module shell#(parameter N=23,M=8)(a,b,c);
input [(N+M):0] a,b;
output [(N+M):0]c;
wire [N:0] aa,bb;
wire [(2*N)+1:0] cc,ncc;
wire norm,ro;
wire zero = (|a)&&(|b);
assign aa = (|a[N+M-1:N]) ? {1'b1,a[N-1:0]} : {1'b0,a[N-1:0]};
assign bb = (|b[N+M-1:N]) ? {1'b1,b[N-1:0]} : {1'b0,b[N-1:0]};
wire [M:0]d,e,f;
wire [M-1:0]biass = 2**(M-1)-1; 
wire [M-1:0]bias = ~biass + 1;
assign c[N+M] = zero? (a[N+M]^b[N+M]):0;                    //sign done
assign norm = cc[2*N+1];
 assign cc = aa*bb;
 assign ncc = norm? cc:cc<<1;
 assign ro = |ncc[N:0];
 assign c[N-1:0] = zero? (ncc[2*N:N+1]+ro):0;  
 assign e[0] =0;                  //mantissa done
genvar i,j;
for(i=0;i<M;i=i+1)
 begin
  Fa fa(a[N+i],b[N+i],e[i],d[i],e[i+1]);
 end
assign d[M] = e[M];
assign f = d + bias +norm;
assign c[N+M-1:N] = zero? f[M-1:0]:0;                   //exponent done

endmodule


