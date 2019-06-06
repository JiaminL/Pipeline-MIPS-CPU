`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 19:03:35
// Design Name: 
// Module Name: DDU
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


module DDU(
    input clk_in, rst,
    input cont, step, mem, inc, dec,
    input [31:0] pc, mem_data, reg_data,
    output reg clk_out,
    output [31:0] addr,
    output [15:0] led,
    output [7:0] an,
    output [6:0] seg
    );
    
    wire effect_step, effect_inc, effect_dec;
    wire [19:0] step_cnt, inc_cnt, dec_cnt;
    reg [7:0] mem_addr;
    reg [4:0] reg_addr;
    wire [31:0] seg7_data;
    
    assign effect_step = (step_cnt == 20'hFFFFE);
    assign effect_inc = (inc_cnt == 20'hFFFFE);
    assign effect_dec = (dec_cnt == 20'hFFFFE);
    assign addr = (mem) ? {22'b0, mem_addr, 2'b0} : {27'b0, reg_addr};
    assign seg7_data = (mem) ? mem_data : reg_data;
    assign led[7:0] = (mem) ? mem_addr : {3'b0, reg_addr}; 
    assign led[15:8] = pc[9:2];
   
    initial clk_out = 0; 
    
    always @(posedge clk_in)
         if(effect_step | cont)
            clk_out <= ~clk_out;
    
    CNT #20 STEP_CNT(
        .ce(step_cnt != 20'hFFFFF), .rst(~step), .clk(clk_in),     //input
        .q(step_cnt)     //output
    );
    CNT #20 INC_CNT(
        .ce(inc_cnt != 20'hFFFFF), .rst(~inc), .clk(clk_in),     //input
        .q(inc_cnt)     //output
    );
    CNT #20 DEC_CNT(
        .ce(dec_cnt != 20'hFFFFF), .rst(~dec), .clk(clk_in),     //input
        .q(dec_cnt)     //output
    );
    
    show7segment SEG7(
        clk_in, 8'hFF, seg7_data,  //input
        an, seg     //output
    );
                
    always @(posedge clk_in,posedge rst)
        if(rst)
            {mem_addr, reg_addr} <= 13'b0;
        else
            if(mem)
                begin
                    if(effect_inc)
                        mem_addr <= mem_addr + 8'h1;
                    else if(effect_dec)
                        mem_addr <= mem_addr - 8'h1;
                end
            else //reg
                begin
                    if(effect_inc)
                        reg_addr <= reg_addr + 8'h1;
                    else if(effect_dec)
                        reg_addr <= reg_addr - 8'h1;
                end
                
endmodule