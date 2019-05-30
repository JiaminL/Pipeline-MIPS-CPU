`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:20:39
// Design Name: 
// Module Name: DM
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


module DataMem(
    input clk,
    input [31:0] Addr32, Show_Addr32,
    input [31:0] WriteData,
    input MemWrite, 
    output [31:0] ReadData, Show_Data
    );
    
    wire [7:0] Addr8, Show_Addr8;
    
    assign Addr8 = Addr32[9:2];
    assign Show_Addr8 = Show_Addr32[9:2];
    
    Data_Memory DM (
        .a(Addr8), // : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        .d(WriteData), // : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        .dpra(Show_Addr8), // : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        .clk(clk), // : IN STD_LOGIC;
        .we(MemWrite), // : IN STD_LOGIC;
        .spo(ReadData), // : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        .dpo(Show_Data) // : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    
endmodule
