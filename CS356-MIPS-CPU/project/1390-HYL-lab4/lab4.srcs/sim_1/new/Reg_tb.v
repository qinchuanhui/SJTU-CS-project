`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/16 09:57:41
// Design Name: 
// Module Name: Reg_tb
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


module Reg_tb(
    );
    reg Clk;
    reg [25:21] readReg1;
    reg [20:16] readReg2;
    reg [4:0] writeReg;
    reg [31:0] writeData;
    reg regwrite;
    wire[31:0] readData1;
    wire[31:0] readData2;
    
    Reg r0(
    .Clk(Clk),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(writeData),
    .regwrite(regwrite),
    .readData1(readData1),
    .readData2(readData2)
    );
    
    always  
    #100 Clk=!Clk;
    initial begin 
    writeData=0;
    writeReg=0;
    readReg1=0;
    readReg2=0;
    Clk=1'b0;
    #100 Clk=1'b0;
    #185;
    regwrite=1'b1;
    writeReg=5'b10101;
    writeData=32'b11111111111111110000000000000000;
    
    #200;
    writeReg=5'b01010;
    writeData=32'b00000000000000001111111111111111;
    
    #200;
    regwrite=1'b0;
    writeReg=5'b00000;
    writeData=32'b00000000000000000000000000000000;
    
    #50;
    readReg1=5'b10101;
    readReg2=5'b01010;
    
    end
    
    
    
    
endmodule
