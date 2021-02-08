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
    input [2:0] ALUOp,
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
            9'b000xxxxxx://addi  addiu  
            OPER=4'b0010;//add
            
            9'b101xxxxxx://jal  
            begin 
            Jal=1;
            OPER=4'b0010;//add
            end
            
            9'b001xxxxxx://i-sub beq   
            OPER=4'b0110;//sub

            9'b010xxxxxx://i-or 
            OPER=4'b0001;//or
            
            9'b011xxxxxx:// i-and
            OPER=4'b0000;
            
            9'b100100000://r-add  
            OPER=4'b0010;//add
           
            9'b100100010: //r-sub
            OPER=4'b0110;//sub
            
            9'b10xxx0100://r-and
              OPER=4'b0000;//and

            9'b10xxx0101: //r-or
             OPER=4'b0001;//or
             
             9'b10xxx1010: //r-slt
            OPER=4'b0111;//slt
             
             9'b100xx1000://r-jr
            begin
             Jr=1;
            OPER=4'b1101;//nothing
            end
            
            9'b100000000://r-sll
            begin
            OPER=4'b1000; //sl
            shiftmux=1;
            end
            
            9'b100000010://r-srl
            begin
            OPER=4'b1001; //sr 
            shiftmux=1;
            end
            
            default: 
            begin
            OPER=4'b0111;
            end
        endcase
    end
endmodule
