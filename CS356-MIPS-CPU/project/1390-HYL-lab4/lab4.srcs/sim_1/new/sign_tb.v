`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/17 11:00:22
// Design Name: 
// Module Name: sign_tb
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


module sign_tb(

    );
    reg [15:0] inst;
    wire [31:0] data;
    
    sign s0(
    .inst(inst),
    .data(data)
    );
    
    initial begin
    inst=0;
    #100
    inst=1;
    #100
    inst=-1;
    #100
    inst=2;
    #100
    inst=-2;
    #100
    inst=14;
    #100
    inst=-14;
    
    end
    
    
endmodule
