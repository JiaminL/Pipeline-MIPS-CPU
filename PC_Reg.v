`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:33:38
// Design Name: 
// Module Name: PC_Reg
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


module PC_Reg(
    input [31:0] PCin,
    input we,
    input rst,
    input clk,
    output reg [31:0] PCout
    );
    
    always@(posedge clk,posedge rst)
        if(rst)
            PCout <= 0;
        else if(we)
            PCout <= PCin;
endmodule
