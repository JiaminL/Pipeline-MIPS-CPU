`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 02:45:59
// Design Name: 
// Module Name: PIPELINE_CPU_tb
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


module PIPELINE_CPU_tb();
    reg clk, rst;
    reg [31:0] Show_IM_Addr, Show_DM_Addr;
    reg [4:0] Show_RF_Addr;
    wire [31:0] Show_PC, Show_IM_Data, Show_DM_Data, Show_RF_Data;
    
    PIPELINE_CPU CPU(
        clk, rst,
        Show_IM_Addr, Show_DM_Addr, Show_RF_Addr,
        Show_PC, Show_IM_Data, Show_DM_Data, Show_RF_Data
    );
    
    initial
        begin
            clk = 0;
            while(1) #5 clk = ~clk;
        end
    
    initial
        begin
            rst = 1;
            Show_RF_Addr = 'b01101;
            Show_IM_Addr = 8;
            Show_DM_Addr = 'h8; 
//            Show_RF_Addr = 5'b10000;
            #15 rst = 0;
//            #95 Show_RF_Addr = 5'b10001;
//            #10 Show_RF_Addr = 5'b10010;
//            #60 Show_DM_Addr = 'h1c; 
//            Show_RF_Addr = 5'b10100;
//            #100 Show_RF_Addr = 5'b11111;
//            #80 Show_RF_Addr = 5'b01000;
//            #280 Show_RF_Addr = 5'b11111;
            #100 $finish;
        end
    

endmodule
