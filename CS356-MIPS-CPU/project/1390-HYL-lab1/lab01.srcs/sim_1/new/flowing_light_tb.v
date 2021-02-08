`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/11 13:04:32
// Design Name: 
// Module Name: flowing_light_tb
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


module flowing_light_tb(

    );
    
    reg clock;
    reg reset;
    wire [7:0] led;
    
    flowing_light u0(
        .clock(clock),
        .reset(reset),
        .led(led));
    
    parameter PERIOD=20;
    
    always #(PERIOD*2) clock= !clock;
    
    initial begin
        clock= 1'b0;
        reset=1'b0;
        #(PERIOD *10) reset = 1'b1;
        #(PERIOD*5) reset =1'b0;
        //#580; reset=1'b1;
    end
    
    
    
    
endmodule
