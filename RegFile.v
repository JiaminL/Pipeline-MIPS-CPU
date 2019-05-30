`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 00:24:41
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk, rst, RegWrite,
    input [4:0] radd1, radd2, radd3, wadd,
    input [31:0] wdata,
    output [31:0] rdata1, rdata2, rdata3
    );
    
    integer i;
    integer SIZE = 32;
    reg [31:0] RF [0:31];
    
    assign rdata1 = RF[radd1];
    assign rdata2 = RF[radd2];
    assign rdata3 = RF[radd3];
        
    always @ (negedge clk, posedge rst)
        begin
            if (rst)
                for (i = 0; i < SIZE;i = i+1) RF[i] <= 0;
            else
                if (RegWrite & wadd != 0)
                    RF[wadd] <= wdata;
        end

endmodule
