`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:20:39
// Design Name: 
// Module Name: IM
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


module InstrMem(
    input clk,
    input [31:0] Addr32, Show_Addr32,
    output [31:0] ReadData, Show_Data
    );
    
    wire [7:0] Addr8, Show_Addr8;
    
    assign Addr8 = Addr32[9:2];
    assign Show_Addr8 = Show_Addr32[9:2];
    
    Instroction_Memory IM (
        .a(Addr8), // : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        .d(0), // : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        .dpra(Show_Addr8), // : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        .clk(clk), // : IN STD_LOGIC;
        .we(1'b0), // : IN STD_LOGIC;
        .spo(ReadData), // : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        .dpo(Show_Data) // : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
endmodule
