`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 10:47:52
// Design Name: 
// Module Name: sign
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


module sign(
    input [15:0]inst,
    output reg [31:0] data
    );
    
    always @ (inst)
    begin
    if (inst[15])
    data[31:16]=16'b1111111111111111;
    else 
    data[31:16]=16'b0000000000000000;
    
    data[15:0]=inst;
    end
    
    
    
endmodule
