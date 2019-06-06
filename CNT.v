`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 19:40:23
// Design Name: 
// Module Name: CNT
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


module CNT #(parameter M = 8)(
    input ce, rst, clk,
    output reg [M-1:0] q
    );
    
    always @(posedge clk, posedge rst)
        if (rst)
            q <= 0;
        else if (ce)
            q <= q + 1;
            
endmodule