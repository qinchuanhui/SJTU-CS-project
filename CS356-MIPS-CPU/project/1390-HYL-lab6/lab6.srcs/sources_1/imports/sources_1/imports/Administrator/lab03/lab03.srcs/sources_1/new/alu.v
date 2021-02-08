`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/15 11:18:23
// Design Name: 
// Module Name: alu
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


module alu(
   input [31:0] input1,
   input [31:0] input2,
   input [3:0] aluCtr,
   output reg  zero,
   output reg [31:0] aluRes
    );
    integer i1,i2;
   always @(input1 or input2 or aluCtr)
   begin 
   case (aluCtr)
   4'b0000: aluRes=input1 & input2; //and
   4'b0001: aluRes=input1 | input2;  //or
   4'b0010: aluRes=input1 +input2;   //add
   4'b0110: aluRes=input1-input2;   //sub
   4'b0111: 
   begin
   i1=input1;i2=input2;
   aluRes=i1 < i2; //slt 
   end
   4'b1101: aluRes=0; //nothing
   4'b1100: //nor
    begin
    aluRes= input1|input2;
    aluRes= ~aluRes;
    end 
   4'b1000://sl
    aluRes=input2<<input1;

   4'b1001://sr
    aluRes=input2>>input1;
   endcase
   
   if (aluRes) zero=0;
   else zero=1;
   end 
    
endmodule
