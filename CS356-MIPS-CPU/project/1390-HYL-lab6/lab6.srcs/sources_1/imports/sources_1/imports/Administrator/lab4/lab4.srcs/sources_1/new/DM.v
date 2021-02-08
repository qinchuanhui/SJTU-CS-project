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


reg [7:0] memFile[0:255];

always @ (address or memread)
begin
if(memread) 
begin
    readData[7:0] = memFile[address+3];
    readData[15:8]= memFile[address+2];
    readData[23:16]= memFile[address+1];
    readData[31:24]= memFile[address];
end 
end

always @ (posedge Clk)
begin
if (memwrite)
begin
    memFile[address+3]=writeData[7:0];
    memFile[address+2]=writeData[15:8];
    memFile[address+1]=writeData[23:16];
    memFile[address]= writeData[31:24];
end 
end

endmodule
