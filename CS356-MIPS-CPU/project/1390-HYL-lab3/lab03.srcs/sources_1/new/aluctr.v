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
    input [1:0] ALUOp,
    input [5:0] Funct,
    output [3:0] Oper
    );
    reg [3:0]OPER;
    assign Oper=OPER;
    
    always@(ALUOp or Funct)
     begin
        casex({ALUOp,Funct})
            8'b00xxxxxx:   OPER=4'b0010;
            8'b01xxxxxx:   OPER=4'b0110;
            8'b1xxx0000:   OPER=4'b0010;
            8'b1xxx0010:   OPER=4'b0110;
            8'b1xxx0100:   OPER=4'b0000;
            8'b1xxx0101:   OPER=4'b0001;
            default:       OPER=4'b0111;
        endcase
    end
endmodule
