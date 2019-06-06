`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 19:15:27
// Design Name: 
// Module Name: Pipeline_TOP
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


module Pipeline_TOP(
    input clk, rst,
    input cont, step, mem, inc, dec,
    output [15:0] led,
    output [7:0] an,
    output [6:0] seg
    );
    
    wire [31:0] addr, pc, mem_data, reg_data;
    wire clk_CPU;
    
    DDU DDU(
        .clk_in(clk), .rst(rst), .cont(cont), .step(step), .mem(mem),     //input
        .inc(inc), .dec(dec), .pc(pc), .mem_data(mem_data), .reg_data(reg_data),    //input
        .clk_out(clk_CPU), .addr(addr), .led(led), .an(an), .seg(seg)     //output
    );
    
    PIPELINE_CPU CPU_MEM(
        .clk(clk_CPU), .rst(rst),     // input
        .Show_DM_Addr(addr), .Show_RF_Addr(addr[4:0]),       // input
        .Show_PC(pc), .Show_DM_Data(mem_data), .Show_RF_Data(reg_data)      // output
    );
endmodule

