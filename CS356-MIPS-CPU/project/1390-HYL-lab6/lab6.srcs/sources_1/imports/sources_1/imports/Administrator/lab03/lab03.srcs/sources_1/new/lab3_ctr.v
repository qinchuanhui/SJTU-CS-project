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
    output [2:0] aluop,
    output branch,
    output jump,
    output alusrc,
    output memwrite,
    output regwrite,
    output memtoreg,
    output memread,
    output regdst
    );
    
    reg [2:0] ALUOp;
    reg Branch;
    reg Jump;
    reg ALUSrc;
    reg MemWrite;
    reg RegWrite;
    reg MemToReg;
    reg MemRead;
    reg RegDst;
    
         
  assign    aluop=   ALUOp ;    
  assign   branch=  Branch;               
  assign   jump=  Jump;                 
  assign   alusrc= ALUSrc;               
  assign   memwrite=MemWrite;             
  assign   regwrite=RegWrite;             
  assign   memread=MemRead;
  assign   memtoreg=MemToReg;              
  assign   regdst  = RegDst;               
            
            
    
    
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
                ALUOp=3'b100;
                Jump=0;
            end
            
            //  I - type
            6'b001000 ://addi
            begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b000;
                Jump=0;
            end
            
            6'b001001 ://addiu
            begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b000;
                Jump=0;
            end
            
            
             6'b001100 ://andi
            begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b011;
                Jump=0;
            end
            
            6'b001101: //ori
             begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b010;
                Jump=0;
            end
            
            6'b001110: //xori
             begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b100;
                Jump=0;
            end
            
            6'b001111: //lui Ö±½Ó×óÒÆ16
             begin
                RegDst=0;
                ALUSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b010;///////
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
                ALUOp=3'b000;
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
                ALUOp=3'b000;
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
                ALUOp=3'b001;
                Jump=0;
            end    
    
            6'b000101://bne
            begin
                RegDst=0;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=1;
                ALUOp=3'b001;
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
                ALUOp=3'b000;
                Jump=1;
            end    
            
         
             6'b000011://jal
            begin
                RegDst=0;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b101;
                Jump=1;
            end    
            
            
            default:
            begin
                RegDst=0;
                ALUSrc=0;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                ALUOp=3'b000;
                Jump=0;
            end    
          endcase
  end
  endmodule
