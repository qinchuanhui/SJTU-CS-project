`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 21:27:19
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb(

    );
    reg Clk;
    reg reset;
    
    Top cpu0(
    .Clk(Clk),
    .reset(reset));
    
    always #50 Clk=!Clk;
    
    initial begin
    $readmemb("C:/Archlabs/inst3.mem",cpu0.im0.instfile);
    $readmemh("C:/Archlabs/mem1.mem",cpu0.dm0.memFile);
    Clk=1;
    reset=1;
    #100 reset=0;
  
    end
    
    
    
endmodule
