`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 09:20:21
// Design Name: 
// Module Name: DM
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


module DM(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memwrite,
    input memread,
    output reg [31:0] readData
    );


reg [31:0] memFile[0:63];

always @ (address or memread)
begin
if(memread) readData=memFile[address];
end

always @ (negedge Clk)
begin
if (memwrite)
memFile[address]=writeData;
end

endmodule
