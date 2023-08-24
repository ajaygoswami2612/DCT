`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2023 01:29:29
// Design Name: 
// Module Name: controlpath
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


module controlpath#(parameter CLOCK_LIM = 6, DCT_POINT = 16, s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011
 , s4 = 3'b100, s5 = 3'b101)
(clk, reset, enable, clr, tally, start_mem, count_en, msps_en, msps_f, out_en, out_f, cord_F, cord_en);
input clk, reset, enable, msps_f, out_f, cord_F;
input [CLOCK_LIM-1:0] tally;
reg [2:0] state;
output reg clr, start_mem, count_en, msps_en, out_en, cord_en;

always @(posedge clk)
 begin
  if(reset)  state <= s0;
  else
   begin
    case(state)
     s0: begin 
          if(enable) state <= s1;
          else state <= s0;
         end
     s1: begin
          if(tally > (DCT_POINT/2)-1) state <= s2;  //check
          else state <= s1;
         end
     s2: begin
          if(tally > DCT_POINT - 2) state <= s3;  //check
          else state <= s2;
         end
     s3: begin
          if(msps_f) state <= s4;
          else state <= s3;
         end
     s4: begin
          if(cord_F) state <= s5;
          else state <= s4;
         end
     s5: begin
          if(out_f) state <= s0;
          else state <= s5;
         end
     default: state <= s0;
     
    endcase 
   end
 end
 
always @(state)
 begin
  case(state)
   s0: begin
        clr = 1;
        start_mem = 0;
        count_en = 0;
        msps_en = 0;
        cord_en = 0;
        out_en = 0;
       end
   s1: begin
        clr = 0;
        start_mem = 1;
        count_en = 1;
        msps_en = 0;
        cord_en = 0;
        out_en = 0;
       end
   s2: begin
        clr = 0; 
        start_mem = 1;
        count_en = 1;
        msps_en = 1;
        cord_en = 0;
        out_en = 0;
       end
   s3: begin
        clr = 0;
        start_mem = 0;
        count_en = 1;
        msps_en = 1;
        cord_en = 0;
        out_en = 0;
       end
   s4: begin
        clr = 0;
        start_mem = 0;
        count_en = 1;
        msps_en = 0;
        cord_en = 1;
        out_en = 0;
       end
   s5: begin
        clr = 0;
        start_mem = 0;
        count_en = 1;
        msps_en = 0;
        cord_en = 0;
        out_en = 1;
       end
   
   default: begin
             clr = 0;
             start_mem = 0;
             count_en = 0;
             msps_en = 0;
             cord_en = 0;
             out_en = 0;
            end
  endcase
 end
endmodule
