`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 10:47:12
// Design Name: 
// Module Name: test_ALU_tb
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


module test_ALU_tb( );
    reg [31:0] a, b;
    reg [4:0] Shamt;
    reg [15:0] in;
    wire [31:0] out;
    
    test_ALU TEST (a,b,in,Shamt,out);
    
    initial
        begin
            in = 16'hffff;
            b = 32'hffffffff;
            a = 32'h000000ff;
            Shamt = 4;
            #10
            b = 32'h0000000f;
            #10 $finish;
        end
            
endmodule
