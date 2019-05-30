`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 21:28:54
// Design Name: 
// Module Name: Hazard_Unit
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


module Hazard_Unit(
    input ID_RegWrite, ID_MemWrite, ID_MemtoReg, ID_Jal,
    input [2:0] ID_JumpBranch, 
    input EX_RegWrite, EX_MemWrite, EX_MemtoReg,
    input MEM_RegWrite, MEM_MemtoReg,
    input [4:0] ID_rsAddr, ID_rtAddr, EX_wrAddr, MEM_wrAddr,
    output EX_Flush, MEM_Flush, WB_Flush,
    output IF_Stall, ID_Stall
    );

    parameter BEQ = 3'd1, BNE = 3'd2, JR = 3'd3, J = 3'd4, JAL = 3'd7, OTHERS = 3'd0;
    
    wire EX_Lw = EX_MemtoReg;
    wire EX_RILw = (EX_RegWrite & ~EX_MemWrite);
    wire ID_RI = (ID_RegWrite & ~ID_MemWrite & ~ID_MemtoReg);
    wire ID_LwSw = (ID_MemWrite | ID_MemtoReg);
    wire ID_Branch = (ID_JumpBranch == BEQ) || (ID_JumpBranch == BNE);
    wire ID_Jr = (ID_JumpBranch == JR);
    wire MEM_Lw = MEM_MemtoReg;
    wire MEM_RILw = MEM_RegWrite;
    
    wire EXw_equ_IDs = (EX_wrAddr != 0) && (EX_wrAddr == ID_rsAddr);
    wire EXw_equ_IDst = (EX_wrAddr != 0) && ((EX_wrAddr == ID_rsAddr) || (EX_wrAddr == ID_rtAddr));
    wire EXw_equ_31 = (EX_wrAddr == 5'd31);
    wire MEMw_equ_31 = (MEM_wrAddr == 5'd31);
    wire MEMw_equ_IDs = (MEM_wrAddr != 0) && (MEM_wrAddr == ID_rsAddr);
    wire MEMw_equ_IDst = (MEM_wrAddr != 0) && ((MEM_wrAddr == ID_rsAddr) || (MEM_wrAddr == ID_rtAddr));
    
    
    // EX_Flush
    assign EX_Flush = (EX_Lw & ID_RI & EXw_equ_IDst)            // EX(lw) + ID(R/I)    (wr == rs/rt) 
                    | (EX_Lw & ID_LwSw & EXw_equ_IDs);          // EX(lw) + ID(lw/sw)    (wr == rs)
    
    // MEM_Flush
    assign MEM_Flush = EX_RILw & ID_Jal & EXw_equ_31;           // EX(R/I/lw) + ID(jal)    (wr == 31)
    
    // WB_Flush
    assign WB_Flush = MEM_RILw & ID_Jal & MEMw_equ_31;          // MEM(R/I/lw) + ID(jal)    (wr == 31)
    
    // IF_Stall, ID_Stall
    assign IF_Stall = ID_Stall;
    assign ID_Stall = (EX_RILw & ID_Branch & EXw_equ_IDst)      // EX(R/I/lw) + ID(branch)    (wr == rs/rt)
                    | (EX_RILw & ID_Jr & EXw_equ_IDs)           // EX(R/I/lw) + ID(jr)    (wr == rs)
                    | (EX_Lw & ID_RI & EXw_equ_IDst)            // EX(lw) + ID(R/I)    (wr == rs/rt)
                    | (EX_Lw & ID_LwSw & EXw_equ_IDs)           // EX(lw) + ID(lw/sw)    (wr == rs)
                    | (MEM_Lw & ID_Branch & MEMw_equ_IDst)      // MEM(lw) + ID(branch)    (wr == rs/rt)
                    | (MEM_Lw & ID_Jr & MEMw_equ_IDs);          // MEM(lw) + ID(jr)    (wr == rs)
        
endmodule
