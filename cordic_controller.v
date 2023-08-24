`timescale 1ns / 1ps


module cordic_controller#(parameter M = 23, E = 8, I = 11, DCT_POINT = 16 )(inp, clk, clr, en, outp, F);
input [((M+E+1)*(DCT_POINT))-1:0] inp;
input en;
input clk, clr;
reg [((M+E+1)*(DCT_POINT/2))-1:0] pass;
wire [((M+E+1)*(DCT_POINT/2))-1:0] pass_shifted;
output reg [((M+E+1)*DCT_POINT) - 1:0]outp;
output reg F = 0;
reg pass_en = 0;
/////////giving x1, y1 inputs //////////////////////////////////////////////////////////

wire [((M+E+1)*(DCT_POINT/2))-1:0]MP[1:0];

assign  MP[1] = inp[0+:((M+E+1)*(DCT_POINT/2))];
assign  MP[0] = inp[((M+E+1)*(DCT_POINT/2)) +: ((M+E+1)*(DCT_POINT/2))];   //p's first


reg  [$clog2(DCT_POINT)-1:0]count3 = 0;

always @(posedge clk)                   //block for giving inputs
 begin
  if(en&&(!clr))
   begin
    count3 <= count3 + 1;
    casez(count3)
    4'b0000: pass <= MP[0];
    4'b???1: pass <= MP[1];
    
    4'b??10: pass <= {MP[0][3*(M+E+1)+:(M+E+1)], MP[0][2*(M+E+1)+:(M+E+1)], MP[0][5*(M+E+1)+:(M+E+1)], MP[0][4*(M+E+1)+:(M+E+1)],
                     MP[0][7*(M+E+1)+:(M+E+1)], MP[0][6*(M+E+1)+:(M+E+1)], MP[0][1*(M+E+1)+:(M+E+1)], MP[0][0*(M+E+1)+:(M+E+1)]};
                     
    4'b?100: pass <= {MP[0][1*(M+E+1)+:(M+E+1)], MP[0][2*(M+E+1)+:(M+E+1)], MP[0][5*(M+E+1)+:(M+E+1)], MP[0][6*(M+E+1)+:(M+E+1)],
                     MP[0][7*(M+E+1)+:(M+E+1)], MP[0][4*(M+E+1)+:(M+E+1)], MP[0][3*(M+E+1)+:(M+E+1)], MP[0][0*(M+E+1)+:(M+E+1)]};
                     
    4'b1000: pass <= MP[0]; 
    endcase
   end
  else
   begin
    count3 <= 0;
    pass <= 0;
   end
 end

/////////////////////giving angle and sequencer inputs////////////////////////// 
wire [M+E:0]angle_mem[DCT_POINT-1:0];

assign angle_mem[0] = 32'h42340000;   //4pi/32
assign angle_mem[1] = 32'h40B40000;    //pi/32
assign angle_mem[2] = 32'h41340000;    //2pi/32
assign angle_mem[3] = 32'h41870000;    //3pi/32
assign angle_mem[4] = 32'h41B40000;    //4pi/32
assign angle_mem[5] = 32'h41E10000;    //5pi/32
assign angle_mem[6] = 32'h42070000;    //6pi/32
assign angle_mem[7] = 32'h421D8000;    //7pi/32
assign angle_mem[8] = 32'h42340000;    //8pi/32
assign angle_mem[9] = 32'h424A8000;    //9pi/32
assign angle_mem[10] = 32'h42610000;    //10pi/32
assign angle_mem[11] = 32'h42778000;   //11pi/32
assign angle_mem[12] = 32'h42870000;   //12pi/32
assign angle_mem[13] = 32'h42924000;   //13pi/32
assign angle_mem[14] = 32'h429D8000;   //14pi/32
assign angle_mem[15] = 32'h42A8C000;   //15pi/32

integer k;
reg [$clog2(DCT_POINT)-1:0]counter4 = 0; // for which input, angles are to be calculated
reg [($clog2(4*DCT_POINT))-1:0]arith[(DCT_POINT/2):0] ;  //temp reg for storing arith values 
                                                         // for 16 point it is (8*6)
reg [$clog2(DCT_POINT):0]angle[(DCT_POINT/2)-1:0]; //for storing angle corresponding to each term
reg [((M+E+1)*(DCT_POINT/4))-1:0]ang; //angle input for hardware
reg [(2*(DCT_POINT/4))-1:0] sequencer;
wire [(2*(DCT_POINT/4))-1:0] sequencer_shifted;
wire [M+E:0] temp_out1, temp_out2;
reg [$clog2(DCT_POINT):0]angle_temp[(DCT_POINT/2)-1:0];

always @(posedge clk)
 begin
  arith[0] = counter4;
  if(en && (!clr))
   begin
    pass_en <= 1;
    if(counter4 == DCT_POINT-1)
     begin
      counter4 <= 0; //no need BTW, it is goint to reset in next clock anyway
     end
    else
     begin
      counter4 <= counter4 + 1;
     end
    
    for(k = 1; k<((DCT_POINT/2)+1); k=k+1)                                                        //for loop-1 angle
     begin
      arith[k] = arith[0] + (2*counter4*(k-1));           //severe problematic line
       case(arith[k][($clog2(4*DCT_POINT))-1:($clog2(4*DCT_POINT))-2])
        2'b00: begin 
                angle[k-1][($clog2(DCT_POINT))-1:0] <=  arith[k][($clog2(DCT_POINT))-1:0];
                angle[k-1][($clog2(DCT_POINT))] <= 1'b0;
               end
        2'b01: begin
                angle[k-1][($clog2(DCT_POINT))-1:0] <= (DCT_POINT - arith[k][($clog2(DCT_POINT))-1:0]);
                angle[k-1][($clog2(DCT_POINT))] <= 1'b1;
               end
        2'b10: begin
                angle[k-1][($clog2(DCT_POINT))-1:0] <=  arith[k][($clog2(DCT_POINT))-1:0];
                angle[k-1][($clog2(DCT_POINT))] <= 1'b1;
               end
        2'b11: begin
                angle[k-1][($clog2(DCT_POINT))-1:0] <= (DCT_POINT - arith[k][($clog2(DCT_POINT))-1:0]);
                angle[k-1][($clog2(DCT_POINT))] <= 1'b0;
               end
       endcase
     end
     
     begin
      casez(count3-1)
       4'b0000: begin
                 for(k = 0; k<((DCT_POINT/2)); k=k+1)
                  angle_temp[k] <= angle[k];
                end
       4'b???1: begin
                 for(k = 0; k<((DCT_POINT/2)); k=k+1)
                  angle_temp[k] <= angle[k];
                end
   
       4'b??10: begin
                angle_temp[0] <= angle[0];
                angle_temp[1] <= angle[1];
                angle_temp[2] <= angle[6];
                angle_temp[3] <= angle[7];
                angle_temp[4] <= angle[4]; 
                angle_temp[5] <= angle[5];
                angle_temp[6] <= angle[2];
                angle_temp[7] <= angle[3];
                end
                     
       4'b?100: begin
                angle_temp[0] <= angle[0];
                angle_temp[1] <= angle[3];
                angle_temp[2] <= angle[4];
                angle_temp[3] <= angle[7];
                angle_temp[4] <= angle[6]; 
                angle_temp[5] <= angle[5];
                angle_temp[6] <= angle[2];
                angle_temp[7] <= angle[1];
                end
                     
       4'b1000: begin
             for(k = 0; k<((DCT_POINT/2)); k=k+1)
                  angle_temp[k] <= angle[k];
                end
       default: begin
                 for(k = 0; k<((DCT_POINT/2)); k=k+1)
                  angle_temp[k] <= angle[k];
                end
     endcase
    end
    
    for(k=0; k<(DCT_POINT/4); k = k+1)                                                       //for loop-2 ang, sequencer
     begin
       case({angle_temp[k][$clog2(DCT_POINT)],angle_temp[(DCT_POINT/2)-1-k][$clog2(DCT_POINT)]})     //case for sign bits
        2'b00: begin
                ang[((M+E+1)*k)+:(M+E+1)] <= angle_mem[angle_temp[(DCT_POINT/2)-1-k][$clog2(DCT_POINT)-1:0]];
                sequencer[(2*k)+:2] <= 2'b00;
               end
        2'b01: begin
                ang[((M+E+1)*k)+:(M+E+1)] <= angle_mem[angle_temp[k][$clog2(DCT_POINT)-1:0]];
                sequencer[(2*k)+:2] <= 2'b01;
               end
        2'b10: begin
                ang[((M+E+1)*k)+:(M+E+1)] <= angle_mem[angle_temp[k][$clog2(DCT_POINT)-1:0]];
                sequencer[(2*k)+:2] <= 2'b10;
               end
        2'b11: begin
                ang[((M+E+1)*k)+:(M+E+1)] <= angle_mem[angle_temp[(DCT_POINT/2)-1-k][$clog2(DCT_POINT)-1:0]];
                sequencer[(2*k)+:2] <= 2'b11;
               end
       endcase
     end
   end
  else
   begin 
    for(k = 1; k<((DCT_POINT/2)+1); k=k+1)
     begin
      arith[k] = 0;
     end
    ang <= 0;
    sequencer <= 0;
    pass_en <= 0;
   end
 end
 
 /////////////// taking outputs/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 reg [$clog2(I+DCT_POINT)-1:0] counter5 = 0;
  always @(posedge clk)
   begin
    if(pass_en && (!clr))
     begin
      if(counter5 == I+DCT_POINT+2)          //trigger2
       begin
        counter5 <= 0;
         F <= 1;
        // pass_en <= 0;
       end
      else
       begin
        F <= 0;
        counter5 <= counter5 + 1;
        if(counter5 > I+1)                                    //trigger1
         begin
          outp[((M+E+1)*(counter5 - I-2))+:(M+E+1)] <= temp_out2;
         end
       end
     end
    else
     begin
      counter5 <= 0;
      F <= 0;
     end
   end
/////////////////////output block completed //////////////////////////////////////////////////////////////////////////////////////////////////////////   
shifter #(.shift(I-1), .L(DCT_POINT/2))shift_reg(.a(sequencer), .b(sequencer_shifted), .clk(clk), .clr(clr));
shifter #(.shift(1), .L((M+E+1)*(DCT_POINT/2)))shift_reg2(.a(pass), .b(pass_shifted), .clk(clk), .clr(clr));
Datapath #(.M(M), .E(E), .I(I), .DCT_POINT(DCT_POINT))datapath(.inp1(pass_shifted), .clk(clk), .clr(clr), .ang(ang), .sequencer(sequencer_shifted), .outp(temp_out1));
shell #(.N(M), .M(E))multiplier(.a(temp_out1), .b(32'h3F1B74EE), .c(temp_out2));

endmodule