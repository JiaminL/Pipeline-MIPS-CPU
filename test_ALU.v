`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 10:45:33
// Design Name: 
// Module Name: test_ALU
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


module test_ALU(
    input [31:0] a,b,
    input [15:0] in,
    input [4:0] Shamt,
    output [31:0] out
    );
    
    assign out = {{16{in[15]}}, in};
endmodule
