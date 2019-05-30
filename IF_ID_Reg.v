`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:33:38
// Design Name: 
// Module Name: IF_ID_Reg
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


module IF_ID_Reg(
    input clk, we, clr, rst,
    input [31:0] IF_IR, IF_NPC,
    output reg [31:0] ID_IR, ID_NPC
    );
        
    always@ (posedge clk,posedge rst)
        if(rst)          
            ID_IR <= 0;
        else if(~we)    //stall
            begin 
                ID_IR <= ID_IR;
                ID_NPC <= ID_NPC;
            end   
        else if(clr)     // Synchronous
            ID_IR <= 0;
        else
            begin 
                ID_IR <= IF_IR;
                ID_NPC <= IF_NPC;
            end    
    
endmodule
