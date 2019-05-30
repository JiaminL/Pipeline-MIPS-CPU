`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 19:22:30
// Design Name: 
// Module Name: Jump_Unit
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


module Jump_Unit(
    input [2:0] JumpBranch,
    input Equ,
    output Jal, 
    output reg ID_Flush,
    output reg [1:0] PCSrc
    );
    
    parameter BEQ = 3'd1, BNE = 3'd2, JR = 3'd3, J = 3'd4, JAL = 3'd7, OTHERS = 3'd0;
    
    // Jal
    assign Jal = (JumpBranch == JAL);
    
    // IR_Flush
    always @(*)
        case(JumpBranch)
            JR, J, JAL: ID_Flush <= 1'b1;
            BEQ:        ID_Flush <= Equ;
            BNE:        ID_Flush <= ~Equ;
            default:    ID_Flush <= 1'b0;
        endcase
        
    // PCSrc
    always @(*)
        case(JumpBranch)
            BEQ, BNE: PCSrc <= (ID_Flush) ?  2'd1 : 2'd0;
            J, JAL: PCSrc <= 2'd2;
            JR: PCSrc <= 2'd3;
            default: PCSrc<= 2'd0; 
        endcase
     
endmodule
