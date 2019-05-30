`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 00:28:57
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a, b,
    input [3:0] ALUOp,
    input [4:0] Shamt,
    output reg [31:0] out
    );
    
    parameter ADD = 4'h0, SUB = 4'h1, SLT = 4'h2, SLTU = 4'h3, AND = 4'h4;
    parameter OR = 4'h5, XOR = 4'h6, NOR = 4'h7, SLL = 4'h8, SRL = 4'h9;
    parameter SRA = 4'ha, SLLV = 4'hb, SRLV = 4'hc, SRAV = 4'hd, LUI = 4'he;  
    
    
    always @(*)
        case(ALUOp)
            ADD    : out <= a + b;
            SUB    : out <= a - b;
            SLT    : out <= ($signed(a) < $signed(b));
            SLTU   : out <= (a < b);
            AND    : out <= a & b;
            OR     : out <= a | b;
            XOR    : out <= a ^ b;
            NOR    : out <= ~(a | b);
            SLL    : out <= b << Shamt;
            SRL    : out <= b >> Shamt;
            SRA    : out <= ($signed(b)) >>> Shamt;
            SLLV   : out <= b << a[4:0];
            SRLV   : out <= b >> a[4:0];
            SRAV   : out <= ($signed(b)) >>> a[4:0];
            LUI    : out <= {b[15:0],16'b0};
            default: out <= 0; 
        endcase
    
endmodule