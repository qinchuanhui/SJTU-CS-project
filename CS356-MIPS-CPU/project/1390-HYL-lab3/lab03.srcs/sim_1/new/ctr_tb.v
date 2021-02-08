`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 10:50:21
// Design Name: 
// Module Name: ctr_tb
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




module ctr_tb(
    );
    
   reg [5:0] opcode;
   
   wire [1:0] aluop;
   wire branch;     
   wire jump;       
   wire alusrc;     
   wire memwrite;   
   wire regwrite;  
   wire memtoreg;  
   wire memread;    
   wire regdst;      
  ctr c0(
   .ALUOp(aluop),
   .Branch(branch),
   .Jump(jump),
   .ALUSrc(alusrc),
   .MemWrite(memwrite),
   .RegWrite(regwrite),
   .MemToReg(memtoreg),
   .MemRead(memread),
   .RegDst(regdst),
   .opcode(opcode));
    
    initial begin
    opcode=0;
    #100;
    #100 opcode=6'b000000;
    #100 opcode=6'b100011;
    
    #100 opcode=6'b101011;
    #100 opcode=6'b000100;
    #100 opcode=6'b000010;
    #100 opcode=6'b010101;
    end 
endmodule
