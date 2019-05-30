`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 16:00:11
// Design Name: 
// Module Name: Control
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


module Control_Unit(
    input [5:0] Opcode, func,
    output reg [2:0] JumpBranch,
    output reg [3:0] ALUOp,
    output reg SignExtend, RegWrite,
    output MemtoReg, MemWrite, ALUSrc, RegDst
    );
    
    // Opcode
    parameter R = 6'h00, ADDI = 6'h08, ADDIU = 6'h09, SLTI = 6'h0a;
    parameter SLTIU = 6'h0b, ANDI = 6'h0c, ORI = 6'h0d, XORI = 6'h0e;
    parameter BEQ = 6'h04, BNE = 6'h05, J = 6'h02, JAL = 6'h03;    
    parameter LUI = 6'h0f, LW = 6'h23, SW = 6'h2b;
    
    // func
    parameter ADD = 6'h20, ADDU = 6'h21, SUB = 6'h22, SUBU = 6'h23;
    parameter AND = 6'h24, OR = 6'h25, XOR = 6'h26, NOR = 6'h27;
    parameter SLT = 6'h2a, SLTU = 6'h2b, SLL = 6'h00, SRL = 6'h02;
    parameter SRA = 6'h03, SLLV = 6'h04, SRLV = 6'h06, SRAV = 6'h07;
    parameter JR = 6'h08;
    
    //ALUOp
    parameter ALU_ADD = 4'h0, ALU_SUB = 4'h1, ALU_SLT = 4'h2, ALU_SLTU = 4'h3;
    parameter ALU_AND = 4'h4, ALU_OR = 4'h5, ALU_XOR = 4'h6, ALU_NOR = 4'h7;
    parameter ALU_SLL = 4'h8, ALU_SRL = 4'h9, ALU_SRA = 4'ha, ALU_SLLV = 4'hb;
    parameter ALU_SRLV = 4'hc, ALU_SRAV = 4'hd, ALU_LUI = 4'he, ALU_DFT = 4'hf;
    
    // JumpBranch
    always @(*)
        case(Opcode)
            BEQ: JumpBranch <= 3'b001;
            BNE: JumpBranch <= 3'b010;
            J  : JumpBranch <= 3'b100;
            JAL: JumpBranch <= 3'b111;
            R  :   if(func == JR)    
                        JumpBranch <= 3'b011;
                    else
                        JumpBranch <= 3'b000;
            default: JumpBranch <= 3'b000;
        endcase
        
    // ALUOp
    always @(*)
        if(Opcode == R)
            case(func)
                ADD, ADDU: ALUOp <= ALU_ADD;
                SUB, SUBU: ALUOp <= ALU_SUB;
                SLT : ALUOp <= ALU_SLT;
                SLTU: ALUOp <= ALU_SLTU;
                AND : ALUOp <= ALU_AND;
                OR  : ALUOp <= ALU_OR;
                XOR : ALUOp <= ALU_XOR;
                NOR : ALUOp <= ALU_NOR;
                SLL : ALUOp <= ALU_SLL;
                SRL : ALUOp <= ALU_SRL;
                SRA : ALUOp <= ALU_SRA;
                SLLV: ALUOp <= ALU_SLLV;
                SRLV: ALUOp <= ALU_SRLV;
                SRAV: ALUOp <= ALU_SRAV;
                default: ALUOp <= ALU_DFT;
            endcase
        else 
            case(Opcode)
                ADDI, ADDIU, LW, SW: ALUOp <= ALU_ADD;
                SLTI : ALUOp <= ALU_SLT;
                SLTIU: ALUOp <= ALU_SLTU;
                ANDI : ALUOp <= ALU_AND;
                ORI  : ALUOp <= ALU_OR;
                XORI : ALUOp <= ALU_XOR;
                LUI  : ALUOp <= ALU_LUI;
                default: ALUOp <= ALU_DFT;
            endcase
                
    // SignExtend
    always @(*)
        case(Opcode)
            ADDI, LW, SW, SLTI: SignExtend <= 1'b1;
            default:  SignExtend <= 1'b0;
        endcase
                
    // RegWriter
    always @(*)
        if(Opcode == R)
            case(func)
                ADD, ADDU, SUB, SUBU, SLT, SLTU, AND, OR, 
                XOR, NOR, SLL, SRL, SRA, SLLV, SRLV, SRAV: 
                    RegWrite <= 1'b1;
                default:    RegWrite <= 1'b0;
            endcase
        else
            case(Opcode)
                ADDI, ADDIU, ANDI, ORI, XORI, LUI, LW, SLTI, SLTIU:
                    RegWrite <= 1'b1;
                default:    RegWrite <= 1'b0;
            endcase
                          
    // MemtoReg
    assign MemtoReg = (Opcode == LW);
    
    // MemWrite
    assign MemWrite = (Opcode == SW);
    
    // ALUSrc
    assign ALUSrc = (Opcode == R);
    
    // RegDst
    assign RegDst = (Opcode == R); 
     
endmodule

