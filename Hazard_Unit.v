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
    input ID_RegWrite, ID_MemWrite, ID_MemtoReg,
    input [2:0] ID_JumpBranch, 
    input EX_RegWrite, EX_MemWrite, EX_MemtoReg,
    input [2:0] EX_JumpBranch,
    input MEM_RegWrite, MEM_MemtoReg,
    input [4:0] ID_rsAddr, ID_rtAddr, EX_wrAddr, MEM_wrAddr,
    output EX_Flush,
    output IF_Stall, ID_Stall
    );

    parameter BEQ = 3'd1, BNE = 3'd2, JR = 3'd3, J = 3'd4, JAL = 3'd7, OTHERS = 3'd0;
    
    wire EX_Lw = EX_MemtoReg;
    wire EX_RILw = EX_RegWrite && (EX_JumpBranch == OTHERS);
    wire ID_RI = (ID_RegWrite & ~ID_MemWrite & ~ID_MemtoReg) && (ID_JumpBranch == OTHERS);
    wire ID_RILwSw = (ID_MemWrite | ID_MemtoReg) && (ID_JumpBranch == OTHERS);
    wire ID_Branch = (ID_JumpBranch == BEQ) || (ID_JumpBranch == BNE);
    wire ID_BranchJr = (ID_JumpBranch == BEQ) || (ID_JumpBranch == BNE) || (ID_JumpBranch == JR); 
    wire MEM_Lw = MEM_MemtoReg;
    
    wire EXw_equ_IDs = (EX_wrAddr != 0) && (EX_wrAddr == ID_rsAddr);
    wire EXw_equ_IDt = (EX_wrAddr != 0) && (EX_wrAddr == ID_rtAddr);
    wire MEMw_equ_IDs = (MEM_wrAddr != 0) && (MEM_wrAddr == ID_rsAddr);
    wire MEMw_equ_IDt = (MEM_wrAddr != 0) && (MEM_wrAddr == ID_rtAddr);
    
    // EX_Flush
    // EX(lw)  -->  (R / I / lw / sw) 
    //   -wr-   =   -rs/rt-  ---rs--
    assign EX_Flush = (EX_Lw & ID_RILwSw & EXw_equ_IDs)
                    | (EX_Lw & ID_RI & EXw_equ_IDt);
    
    // IF_Stall, ID_Stall
    // EX(R / I / lw)  -->  ID(beq / bne / jr)
    //    ----wr----   =       --rs/rt--  -rs-
    // EX(lw)  -->  ID(R / I / lw / sw)
    //   -wr-   =     -rs/rt-  --rs--
    // MEM(lw)  -->  ID(beq / bne / jr)
    //     -wr-   =     --rs/rt--   rs
    assign IF_Stall = ID_Stall;
    assign ID_Stall = (EX_RILw & ID_BranchJr & EXw_equ_IDs)
                    | (EX_RILw & ID_Branch & EXw_equ_IDt)
                    | (EX_Lw & ID_RILwSw & EXw_equ_IDs)
                    | (EX_Lw & ID_RI & EXw_equ_IDt)
                    | (MEM_Lw & ID_BranchJr & MEMw_equ_IDs)
                    | (MEM_Lw & ID_Branch & MEMw_equ_IDt);
        
endmodule
