`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/15 11:35:51
// Design Name: 
// Module Name: alu_tb
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


module alu_tb(

    );
    reg [31:0] input1;
    reg [31:0] input2;
    reg [3:0]  aluCtr;
    wire[31:0] aluRes;
    wire  zero;
    
    alu a0(
    .input1(input1),
    .input2(input2),
    .aluCtr(aluCtr),
    .aluRes(aluRes),
    .zero(zero)
    );
    
    initial begin
    input1=0;
    input2=0;
    aluCtr=0;
    #100;
    input1=15;
    input2=10;
    #100 aluCtr=4'b0001;
    #100 aluCtr=4'b0010;
    #100 aluCtr=4'b0110;
    #100;
    input1=10;
    input2=15;
    #100;
    input1=15;
    input2=10;
    aluCtr=4'b0111;
    #100;
    input1=10;
    input2=15;
    #100;
    aluCtr=4'b1100;
    input1=1;
    input2=1;
    #100 input1=16;
    
    end
    
    
endmodule
