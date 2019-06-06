`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 16:04:34
// Design Name: 
// Module Name: PIPELINE_CPU
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


module PIPELINE_CPU(
    input clk, rst,
//    input [15:0] SW,
//    output [15:0] LED
    input [31:0] Show_IM_Addr, Show_DM_Addr,
    input [4:0] Show_RF_Addr,
    output [31:0] Show_PC, Show_IM_Data, Show_DM_Data, Show_RF_Data
    );
//    wire [31:0] Show_IM_Addr, Show_DM_Addr;
//    wire [4:0] Show_RF_Addr;
//    wire [31:0] Show_PC, Show_IM_Data, Show_DM_Data, Show_RF_Data;
//    assign Show_DM_Addr = SW;
//    assign LED = Show_DM_Data;
    
    // IF
    wire [1:0] ID_PCSrc;
    wire [31:0] IF_NPC, ID_BranchPC, ID_JimmPC, ID_JrPC;
    wire [31:0] IF_PC_In, IF_PC_Out, IF_IM_Data;
    wire IF_Stall;    // output from Hazard Unit
     
    // PC
    MUX3or4 PC_MUX(
        IF_NPC, ID_BranchPC, ID_JimmPC, ID_JrPC,    // input
        ID_PCSrc,    // input
        IF_PC_In    //output
    );
    PC_Reg PC(
        .rst(rst), .clk(clk), .PCin(IF_PC_In), .we(~IF_Stall),    // input
        .PCout(IF_PC_Out)    // output
    );
    ADD NPC_ADD(
        IF_PC_Out, 32'd4,    // input
        IF_NPC    //output
    );
    assign Show_PC = IF_PC_Out; 
    
    // Intrustion Memory
    InstrMem IM(
        .clk(clk), .Addr32(IF_PC_Out), .Show_Addr32(Show_IM_Addr),    // input
        .ReadData(IF_IM_Data), .Show_Data(Show_IM_Data)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // IF/ID.Register
    wire [31:0] IF_IR, ID_IR, ID_NPC;
    wire ID_Flush;
    wire ID_Stall;    // output from Hazard Unit
    
    assign IF_IR = IF_IM_Data;
    IF_ID_Reg IF_ID_REG(
        .clk(clk), .we(~ID_Stall), .clr(ID_Flush), .rst(rst),    // input
        .IF_IR(IF_IR), .IF_NPC(IF_NPC),    // input
        .ID_IR(ID_IR), .ID_NPC(ID_NPC)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // ID
    wire [5:0] ID_Opcode = ID_IR[31:26];
    wire [5:0] ID_Func = ID_IR[5:0];
    wire [4:0] ID_rsAddr = ID_IR[25:21];
    wire [4:0] ID_rtAddr = ID_IR[20:16];
    wire [4:0] ID_rdAddr = ID_IR[15:11];
    wire [4:0] ID_Shamt = ID_IR[10:6];
    wire [15:0] ID_Imm = ID_IR[15:0];
    wire [25:0] ID_Address = ID_IR[25:0];
      
    // Control Unit
    wire [2:0] ID_JumpBranch;
    wire [3:0] ID_ALUOp;
    wire ID_SignExtend, ID_RegWrite, ID_MemtoReg, ID_MemWrite, ID_ALUSrc, ID_RegDst;
    wire ID_Equ;
    
    Control_Unit Control_Unit(
        .Opcode(ID_Opcode), .func(ID_Func),    // input
        .JumpBranch(ID_JumpBranch), .ALUOp(ID_ALUOp), .SignExtend(ID_SignExtend),   // output
        .RegWrite(ID_RegWrite), .MemtoReg(ID_MemtoReg), .MemWrite(ID_MemWrite),   // output
        .ALUSrc(ID_ALUSrc), .RegDst(ID_RegDst)    // output
    ); 
    Jump_Unit Jump_Unit(
        .JumpBranch(ID_JumpBranch), .Equ(ID_Equ),    // input
        .ID_Flush(ID_Flush), .PCSrc(ID_PCSrc)    //output
    );
    
    // Register File
    wire WB_RegWrite;
    wire [4:0] WB_wrAddr;
    wire [31:0] ID_rsData, ID_rtData, WB_Data;
    
    RegFile RF(
        .clk(clk), .rst(rst), .RegWrite(WB_RegWrite),    // input
        .radd1(ID_rsAddr), .radd2(ID_rtAddr), .radd3(Show_RF_Addr),    // input 
        .wadd(WB_wrAddr), .wdata(WB_Data),    // input
        .rdata1(ID_rsData), .rdata2(ID_rtData), .rdata3(Show_RF_Data)    // ouput
    );
    
    // Equ
    wire [31:0] ID_Equ_In1, ID_Equ_In2, MEM_ALUorNPC;
    wire ID_Forward1, ID_Forward2;    // output from Bypath Unit
    
    MUX2 EquIn1_Mux(
        .data0(ID_rsData), .data1(MEM_ALUorNPC),    // input
        .s(ID_Forward1),    // input
        .out(ID_Equ_In1)    // output
    );
    MUX2 EquIn2_Mux(
        .data0(ID_rtData), .data1(MEM_ALUorNPC),    // input
        .s(ID_Forward2),    // input
        .out(ID_Equ_In2)    // output
    );
    Equality EQU(
        ID_Equ_In1, ID_Equ_In2,    // input
        ID_Equ    // output
    );
    
    // Extend
    wire [31:0] ID_Sign_Imm, ID_Unsign_Imm, ID_ExtImm;
    
    Sign_Extend SIGN_Extend(
        ID_Imm, ID_Sign_Imm
    );
    Unsign_Extend UNSIGN_Extend(
        ID_Imm, ID_Unsign_Imm
    );
    MUX2 ImmMUX(
        .data0(ID_Unsign_Imm), .data1(ID_Sign_Imm),    // input
        .s(ID_SignExtend),    // input
        .out(ID_ExtImm)    // output
    );
    
    // J / Jal Address
    assign ID_JimmPC = {ID_NPC[31:28], ID_Address, 2'b00};
    
    // Beq / Bne  Address
    wire [31:0] ID_SignImm_sl2 = ID_Sign_Imm << 2;
    ADD Branch_ADD(
        ID_NPC, ID_SignImm_sl2,    // input
        ID_BranchPC    // output
    );
    
    // Jr Address
    assign ID_JrPC = ID_Equ_In1;
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // ID/EX.Register
    wire EX_RegWrite, EX_MemtoReg, EX_MemWrite, EX_ALUSrc, EX_RegDst;
    wire [2:0] EX_JumpBranch;
    wire [3:0] EX_ALUOp;
    wire [31:0] EX_rsData, EX_rtData, EX_ExtImm, EX_NPC;
    wire [4:0] EX_rsAddr, EX_rtAddr, EX_rdAddr, EX_Shamt;
    wire EX_Flush;    // output from Harzard Unit
    
    ID_EX_Reg ID_EX_REG(
        .clk(clk), .clr(EX_Flush), .rst(rst),    // input
        .ID_RegWrite(ID_RegWrite), .ID_MemtoReg(ID_MemtoReg), .ID_MemWrite(ID_MemWrite),    // input
        .ID_ALUSrc(ID_ALUSrc), .ID_RegDst(ID_RegDst), .ID_ALUOp(ID_ALUOp), .ID_JumpBranch(ID_JumpBranch),    // input
        .ID_rsData(ID_rsData), .ID_rtData(ID_rtData), .ID_NPC(ID_NPC), .ID_ExtImm(ID_ExtImm),    // input
        .ID_rsAddr(ID_rsAddr), .ID_rtAddr(ID_rtAddr), .ID_rdAddr(ID_rdAddr), .ID_Shamt(ID_Shamt),    // input
        .EX_RegWrite(EX_RegWrite), .EX_MemtoReg(EX_MemtoReg), .EX_MemWrite(EX_MemWrite),    // output
        .EX_ALUSrc(EX_ALUSrc), .EX_RegDst(EX_RegDst), .EX_ALUOp(EX_ALUOp),.EX_JumpBranch(EX_JumpBranch),    // output
        .EX_rsData(EX_rsData), .EX_rtData(EX_rtData), .EX_NPC(EX_NPC), .EX_ExtImm(EX_ExtImm),    // output
        .EX_rsAddr(EX_rsAddr), .EX_rtAddr(EX_rtAddr), .EX_rdAddr(EX_rdAddr), .EX_Shamt(EX_Shamt)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // EX
    wire [31:0] EX_FinalRs, EX_FinalRt, EX_ALUin_A, EX_ALUin_B, EX_ALUOut, EX_ALUorNPC;
    wire [4:0] EX_wrAddr;
    wire [1:0] EX_ForwardA, EX_ForwardB;
    wire EX_Jal;
    
    IS_Jal IS_JAL(
        .JumpBranch(EX_JumpBranch), .Jal(EX_Jal)
    );
    
    // ALU input A
    MUX3or4 Rs_MUX(
        .data0(EX_rsData), .data1(MEM_ALUorNPC), .data2(WB_Data),    // input
        .s(EX_ForwardA),    // input
        .out(EX_FinalRs)    // output
    );
    assign EX_ALUin_A = EX_FinalRs;
    
    // ALU input B
    MUX3or4 Rt_MUX(
        .data0(EX_rtData), .data1(MEM_ALUorNPC), .data2(WB_Data),    // input
        .s(EX_ForwardB),    // input
        .out(EX_FinalRt)    // output
    );
    MUX2 ALUB_MUX(
        .data0(EX_ExtImm), .data1(EX_FinalRt),    // input
        .s(EX_ALUSrc),    // input
        .out(EX_ALUin_B)    // output
    );
    
    // ALU
    ALU ALU(
        EX_ALUin_A, EX_ALUin_B, EX_ALUOp, EX_Shamt,    // input
        EX_ALUOut    // output
    );
    MUX2 ALU0rNPC_MUX(
        .data0(EX_ALUOut), .data1(EX_NPC),
        .s(EX_Jal),
        .out(EX_ALUorNPC)
    );
    
    
    // Write Regester Address
    MUX3or4 #(5) WRAddr_MUX(
        .data0(EX_rtAddr), .data2(EX_rdAddr), .data1(5'd31), .data3(5'd31),    // input
        .s({EX_RegDst,EX_Jal}),    // input
        .out(EX_wrAddr)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // EX/MEM.Register
    wire MEM_RegWrite, MEM_MemtoReg, MEM_MemWrite;
    wire [31:0] MEM_wmData;
    wire [2:0] MEM_JumpBranch;
    wire [4:0] MEM_rtAddr, MEM_wrAddr;
    wire [31:0] EX_wmData = EX_FinalRt;
    
    EX_MEM_Reg EX_MEM_REG(
        .clk(clk), .rst(rst),    // input
        .EX_RegWrite(EX_RegWrite), .EX_MemtoReg(EX_MemtoReg), .EX_MemWrite(EX_MemWrite), .EX_ALUorNPC(EX_ALUorNPC),    // input
        .EX_JumpBranch(EX_JumpBranch), .EX_wmData(EX_wmData), .EX_rtAddr(EX_rtAddr), .EX_wrAddr(EX_wrAddr),    // input
        .MEM_RegWrite(MEM_RegWrite), .MEM_MemtoReg(MEM_MemtoReg), .MEM_MemWrite(MEM_MemWrite), .MEM_ALUorNPC(MEM_ALUorNPC),    // output
        .MEM_JumpBranch(MEM_JumpBranch), .MEM_wmData(MEM_wmData), .MEM_rtAddr(MEM_rtAddr), .MEM_wrAddr(MEM_wrAddr)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // MEM
    wire [31:0] MEM_Final_WData, MEM_MDR;
    wire MEM_Forwardwm;    // output from Bypath Unit
    
    MUX2 WMData_MUX(
        .data0(MEM_wmData), .data1(WB_Data),    // input
        .s(MEM_Forwardwm),    // input
        .out(MEM_Final_WData)    // output
    );
    DataMem DM(
        .clk(clk),    // input
        .Addr32(MEM_ALUorNPC), .Show_Addr32(Show_DM_Addr),    // input
        .WriteData(MEM_Final_WData), .MemWrite(MEM_MemWrite),    // input 
        .ReadData(MEM_MDR), .Show_Data(Show_DM_Data)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // MEM/WB.Register
    wire WB_MemtoReg;
    wire [31:0] WB_MDR, WB_ALUorNPC;
    
    MEM_WB_Reg MEM_WB_REG(
        .clk(clk), .rst(rst),    // input
        .MEM_RegWrite(MEM_RegWrite), .MEM_MemtoReg(MEM_MemtoReg),    // input
        .MEM_MDR(MEM_MDR), .MEM_ALUorNPC(MEM_ALUorNPC),    // input
        .MEM_wrAddr(MEM_wrAddr),    // input
        .WB_RegWrite(WB_RegWrite), .WB_MemtoReg(WB_MemtoReg),    // output
        .WB_MDR(WB_MDR), .WB_ALUorNPC(WB_ALUorNPC),    // output
        .WB_wrAddr(WB_wrAddr)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // WB
    MUX2 WBData_MUX(
        .data0(WB_ALUorNPC), .data1(WB_MDR),    // input
        .s(WB_MemtoReg),    // input
        .out(WB_Data)    // output
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // Harzard Unit
    Hazard_Unit Hazard_Unit(
        .ID_JumpBranch(ID_JumpBranch),    // input 
        .ID_RegWrite(ID_RegWrite), .ID_MemWrite(ID_MemWrite), .ID_MemtoReg(ID_MemtoReg),    // input
        .EX_RegWrite(EX_RegWrite), .EX_MemWrite(EX_MemWrite),    // input
        .EX_MemtoReg(EX_MemtoReg), .EX_JumpBranch(EX_JumpBranch),    // input
        .MEM_RegWrite(MEM_RegWrite), .MEM_MemtoReg(MEM_MemtoReg),    // input
        .ID_rsAddr(ID_rsAddr), .ID_rtAddr(ID_rtAddr), .EX_wrAddr(EX_wrAddr), .MEM_wrAddr(MEM_wrAddr),    // input
        .EX_Flush(EX_Flush), .IF_Stall(IF_Stall), .ID_Stall(ID_Stall)    // output
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // Bypath Unit
    Bypath_Unit Bypath_Unit( 
        .ID_JumpBranch(ID_JumpBranch),    // input
        .EX_RegWrite(EX_RegWrite), .EX_MemWrite(EX_MemWrite), .EX_JumpBranch(EX_JumpBranch),    // input
        .MEM_RegWrite(MEM_RegWrite), .MEM_MemWrite(MEM_MemWrite), 
        .MEM_MemtoReg(MEM_MemtoReg), .MEM_JumpBranch(MEM_JumpBranch),    // input
        .WB_RegWrite(WB_RegWrite), .WB_MemtoReg(WB_MemtoReg),    // input
        .ID_rsAddr(ID_rsAddr), .ID_rtAddr(ID_rtAddr),    // input
        .EX_rsAddr(EX_rsAddr), .EX_rtAddr(EX_rtAddr),    // input
        .MEM_rtAddr(MEM_rtAddr), .MEM_wrAddr(MEM_wrAddr),    // input
        .WB_wrAddr(WB_wrAddr),     // input
        .ID_Forward1(ID_Forward1), .ID_Forward2(ID_Forward2),    // output 
        .EX_ForwardA(EX_ForwardA), .EX_ForwardB(EX_ForwardB),    // output 
        .MEM_Forwardwm(MEM_Forwardwm)    // output 
    );
    
    
    
endmodule
