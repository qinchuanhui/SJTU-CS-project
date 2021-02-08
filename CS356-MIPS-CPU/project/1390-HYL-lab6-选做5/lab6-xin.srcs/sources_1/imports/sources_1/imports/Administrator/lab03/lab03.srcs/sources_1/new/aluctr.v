`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/15 09:29:00
// Design Name: 
// Module Name: aluctr
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


module aluctr(
    input [3:0] ALUOp,
    input [5:0] Funct,
    output [3:0] Oper,
    output reg shiftmux,
    output reg Jal,
    output reg Jr
    );
    
    reg [3:0]OPER;
    
    assign Oper=OPER;
    
    always@(ALUOp or Funct)
     begin
        shiftmux=0;
        Jal=0;
        Jr=0;
        casex({ALUOp,Funct})
            10'b0000xxxxxx://addi,lw,sw,j  
            OPER=4'b0010;//add
            
            10'b0101xxxxxx://jal  
            begin 
            Jal=1;
            OPER=4'b0010;//add
            end
            
            10'b0001xxxxxx:// beq   
            OPER=4'b0110;//sub

            10'b0010xxxxxx://i-or 
            OPER=4'b0001;//or
            
            10'b0011xxxxxx:// i-and
            OPER=4'b0000;
            
            10'b1000xxxxxx: //addiu
            OPER=4'b0011;
            
            10'b1010xxxxxx: //xori
            OPER=4'b1010;
            
            10'b1001xxxxxx: //lui
            OPER=4'b1011;
            
            10'b1011xxxxxx: //bne
            OPER=4'b1100;
            
            10'b1100xxxxxx: //slti
            OPER=4'b0111;
            
            10'b1101xxxxxx: //sltiu
            OPER=4'b1111;
            
            10'b0100100000://r-add addu 
            OPER=4'b0010;//add
           
            10'b0100100010: //r-sub subu
            OPER=4'b0110;//sub
            
            10'b0100100100://r-and
              OPER=4'b0000;//and

            10'b0100100101: //r-or
             OPER=4'b0001;//or
            
            10'b0100100110: //r-xor
             OPER=4'b1010;//xor
            
            10'b0100100111: //r-nor
             OPER=4'b1110;//nor
            
             10'b0100101010: //r-slt
            OPER=4'b0111;//slt
             
             10'b0100101011: //r-sltu
            OPER=4'b1111;//sltu
             
             10'b0100001000://r-jr
             begin
             Jr=1;
            OPER=4'b1101;//nothing
            end
            
            10'b0100000000://r-sll
            begin
            OPER=4'b1000; //sl
            shiftmux=1;
            end
            
            10'b0100000100: //r-sllv
             OPER=4'b1000;//sl
            
            10'b0100000010://r-srl
            begin
            OPER=4'b1001; //sr 
            shiftmux=1;
            end
            
            10'b0100000110: //srlv
             OPER=4'b1001; //sr 
             
            10'b0100000011://r-sra
            begin
            OPER=4'b0100; //sra
            shiftmux=1;
            end
             
            10'b0100000111://srav
            OPER=4'b0100; //sra
            
            default: 
            begin
            OPER=4'b1101;//nothing
            end
        endcase
    end
endmodule
