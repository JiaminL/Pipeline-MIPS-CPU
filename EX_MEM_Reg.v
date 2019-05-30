`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:33:38
// Design Name: 
// Module Name: EX_MEM_Reg
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


module EX_MEM_Reg(
    input clk, clr, rst,
    input EX_RegWrite, EX_MemtoReg, EX_MemWrite,
    input [31:0] EX_ALUOut, EX_wmData,
    input [4:0] EX_rtAddr, EX_wrAddr,
    output reg MEM_RegWrite, MEM_MemtoReg, MEM_MemWrite,
    output reg [31:0] MEM_ALUOut, MEM_wmData,
    output reg [4:0] MEM_rtAddr, MEM_wrAddr
    );
        
    always@ (posedge clk,posedge rst)
        if(rst)
            begin
                MEM_RegWrite <= 0;
                MEM_MemWrite <= 0;
            end
        else if(clr)     // Synchronous
            begin
                MEM_RegWrite <= 0;
                MEM_MemWrite <= 0;
            end
        else
            begin
                MEM_RegWrite <= EX_RegWrite;
                MEM_MemtoReg <= EX_MemtoReg;
                MEM_MemWrite <= EX_MemWrite;
                MEM_ALUOut <= EX_ALUOut;
                MEM_wmData <= EX_wmData;
                MEM_rtAddr <= EX_rtAddr;
                MEM_wrAddr <= EX_wrAddr;
            end    
    
endmodule
