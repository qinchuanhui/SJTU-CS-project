`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/15 09:54:34
// Design Name: 
// Module Name: aluctr_tb
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


module aluctr_tb(

    );
    
    reg [1:0]ALUOp;
    reg [5:0]Funct;
    wire [3:0] Oper;
    
    aluctr actr(
    .ALUOp(ALUOp),
    .Funct(Funct),
    .Oper(Oper));
    
    initial begin
    ALUOp=0;
    Funct=0;
    
    #100 Funct=6'bxxxxxx;
    #60
    ALUOp=2'bx1;
    #60 
    ALUOp=2'b1x;
    Funct=6'bxx0000;
    #60 Funct=6'bxx0010;
    #60 Funct=6'bxx0100;
    #60 Funct=6'bxx0101;
    #60 Funct=6'bxx1010;
   
   /*
   #160 ALUOp=2'b01;
   #60 ALUOp=2'b10;
   #60 Funct=6'b000010;
   #60 Funct=6'b000100;
   #60 Funct=6'b000101;
   #60 Funct=6'b001010;
   */
    end 
    
endmodule
