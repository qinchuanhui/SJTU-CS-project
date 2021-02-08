`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 10:05:41
// Design Name: 
// Module Name: ctr
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


module ctr(
    input [5:0] opcode,
    output reg [1:0] ALUOp,
    output reg Branch,
    output reg Jump,
    output reg ALUSrc,
    output reg MemWrite,
    output reg RegWrite,
    output reg MemToReg,
    output reg MemRead,
    output reg RegDst
    );
    

    always@(opcode)
        begin
            case(opcode)
            6'b000000://R
            begin
                RegDst=1;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=2'b10;
                Jump=0;
            end
            
            6'b100011://lw
            begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=1;
                RegWrite=1;
                MemRead=1;
                MemWrite=0;
                Branch=0;
                ALUOp=2'b00;
                Jump=0;
            end    
    
            6'b101011://sw
            begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=1;
                Branch=0;
                ALUOp=2'b00;
                Jump=0;
            end    
    
            6'b000100://beq
            begin
                RegDst=0;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=1;
                ALUOp=2'b01;
                Jump=0;
            end    
    
            6'b000010://jump
            begin
                RegDst=0;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=2'b00;
                Jump=1;
            end    
            
            default://lw
            begin
                RegDst=0;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=2'b00;
                Jump=0;
            end    
          endcase
  end
  endmodule
