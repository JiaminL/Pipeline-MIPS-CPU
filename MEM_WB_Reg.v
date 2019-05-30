`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:33:38
// Design Name: 
// Module Name: MEM_WB_Reg
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


module MEM_WB_Reg(
    input clk, clr, rst,
    input MEM_RegWrite, MEM_MemtoReg,
    input [31:0] MEM_MDR, MEM_ALUOut,
    input [4:0] MEM_wrAddr,
    output reg WB_RegWrite, WB_MemtoReg,
    output reg [31:0] WB_MDR, WB_ALUOut,
    output reg [4:0] WB_wrAddr
    );
        
    always@ (posedge clk,posedge rst)
        if(rst)
            WB_RegWrite <= 0;
        else if(clr)    // Synchronous
            WB_RegWrite <= 0;
        else
            begin
                WB_RegWrite <= MEM_RegWrite;
                WB_MemtoReg <= MEM_MemtoReg;
                WB_MDR <= MEM_MDR;
                WB_ALUOut <= MEM_ALUOut;
                WB_wrAddr <= MEM_wrAddr;
            end    
    
endmodule
