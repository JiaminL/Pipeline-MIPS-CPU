`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:33:38
// Design Name: 
// Module Name: ID_EX_Reg
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


module ID_EX_Reg(
    input clk, clr, rst,
    input ID_RegWrite, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegDst,
    input [3:0] ID_ALUOp,
    input [31:0] ID_rsData, ID_rtData, ID_ExtImm,
    input [4:0] ID_rsAddr, ID_rtAddr, ID_rdAddr, ID_Shamt,
    output reg EX_RegWrite, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, EX_RegDst,
    output reg [3:0] EX_ALUOp,
    output reg [31:0] EX_rsData, EX_rtData, EX_ExtImm,
    output reg [4:0] EX_rsAddr, EX_rtAddr, EX_rdAddr, EX_Shamt
    );
        
    always@ (posedge clk,posedge rst)
        if(rst)
            begin
                EX_RegWrite <= 0;
                EX_MemWrite <= 0;
            end
        else if(clr)    // Synchronous
            begin
                EX_RegWrite <= 0;
                EX_MemWrite <= 0;
            end
        else
            begin
                EX_RegWrite <= ID_RegWrite;
                EX_MemtoReg <= ID_MemtoReg;
                EX_MemWrite <= ID_MemWrite;
                EX_ALUSrc <= ID_ALUSrc;
                EX_RegDst <= ID_RegDst;
                EX_ALUOp <= ID_ALUOp;
                EX_rsData <= ID_rsData;
                EX_rtData <= ID_rtData;
                EX_ExtImm <= ID_ExtImm;
                EX_rsAddr <= ID_rsAddr;
                EX_rtAddr <= ID_rtAddr;
                EX_rdAddr <= ID_rdAddr;
                EX_Shamt <= ID_Shamt;
            end    
    
endmodule
