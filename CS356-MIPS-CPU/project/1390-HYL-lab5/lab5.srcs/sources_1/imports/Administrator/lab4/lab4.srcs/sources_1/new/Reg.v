`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/16 09:48:12
// Design Name: 
// Module Name: Reg
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


module Reg(
 input Clk,
 input [25:21] readReg1,
 input [20:16] readReg2,
 input [4:0] writeReg,
 input [31:0] writeData,
 input regwrite,
 input reset,
 output reg [31:0] readData1,
 output reg [31:0] readData2
    );
    
 reg [31:0] regFile[0:31];
 
 
 always @ (readReg1 or readReg2 or writeReg)
 begin
 readData1<=regFile[readReg1];
 readData2<=regFile[readReg2];
 end
 
 integer i;
 always @ (reset or negedge Clk)
 begin
  if(reset)
    for(i=0;i<=31;i=i+1)
    regFile[i]=0;
    
 else if(regwrite)
         regFile[writeReg]= writeData; 
 end
 
 
    
    
    
    
    
    
    
    
    
    
endmodule
