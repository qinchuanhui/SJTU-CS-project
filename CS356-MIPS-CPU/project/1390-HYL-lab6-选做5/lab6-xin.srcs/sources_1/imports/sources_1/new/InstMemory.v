`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 18:13:02
// Design Name: 
// Module Name: InstMemory
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


module InstMemory(
    input [31:0] readaddress, 
    output reg [31:0] readinst   
    );
    
    reg [7:0] instfile[0:255];
    
    always @ (readaddress)
    begin 
    readinst[7:0] = instfile[readaddress+3];
    readinst[15:8]= instfile[readaddress+2];
    readinst[23:16]= instfile[readaddress+1];
    readinst[31:24]= instfile[readaddress];
    end
    
    
endmodule
