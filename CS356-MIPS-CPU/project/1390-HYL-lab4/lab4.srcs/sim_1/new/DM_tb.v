`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 09:25:31
// Design Name: 
// Module Name: DM_tb
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


module DM_tb(

    );
    
    reg Clk;
    reg [31:0] address;
    reg [31:0] writeData;
    reg memwrite;
    reg memread;
    wire [31:0] readData;
    
    DM m0(
    .Clk(Clk),
    .address(address),
    .writeData(writeData),
    .memwrite(memwrite),
    .memread(memread),
    .readData(readData)    
    );
    
    always #100 Clk=!Clk;
    
    initial begin
    Clk=0;
    writeData=0;
    address=0;
    
    // 两种激励文件的写法
    /*#185;
    memwrite=1'b1;
    address=32'b00000000000000000000000000000111;
    writeData=32'he0000000;
    #100;
    memwrite=1'b1;
    writeData=32'hffffffff;
    address=32'h00000006;
    #185;
    memread=1'b1;
    memwrite=1'b0;
    address=7;
    
    #80;
    memwrite=1;
    address=8;
    writeData=32'haaaaaaaa;
    #80;
    memwrite=0;
    memread=1;
    address=6;
      */
    #100 Clk=0;
    #85
    memwrite=1;
    address=15;
    writeData=-16777216;
    
    #220 memread=1;
    memwrite=0;  
       
    end
    
    
    
    
endmodule
