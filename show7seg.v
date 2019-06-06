`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 19:41:57
// Design Name: 
// Module Name: show7seg
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


module show7segment(
    input clk_100M,
    input [7:0] Enable,
    input [31:0] in,
    output reg [7:0] an,
    output reg [6:0] seg
    );
    
    reg clk_500, en;
    reg [2:0] address;
    reg [17:0] cnt;
    reg [3:0] x;
    wire [3:0] bcdin7, bcdin6, bcdin5, bcdin4, bcdin3, bcdin2, bcdin1, bcdin0;
    
    assign {bcdin0, bcdin1, bcdin2, bcdin3, bcdin4, bcdin5, bcdin6, bcdin7} = in;
    
    initial
        begin
            address=0;
            cnt = 0;
            x=0;
        end
    
    always @ (*)
        case(address)
            3'd0:an=8'b01111111;
            3'd1:an=8'b10111111;
            3'd2:an=8'b11011111;
            3'd3:an=8'b11101111;
            3'd4:an=8'b11110111;
            3'd5:an=8'b11111011;
            3'd6:an=8'b11111101;
            3'd7:an=8'b11111110;
        endcase
    
    always @ (*)
        if(en)
            case(x)
                4'd0:seg = 7'b1000000;
                4'd1:seg = 7'b1111001;
                4'd2:seg = 7'b0100100;
                4'd3:seg = 7'b0110000;
                4'd4:seg = 7'b0011001;
                4'd5:seg = 7'b0010010;
                4'd6:seg = 7'b0000010;
                4'd7:seg = 7'b1111000;
                4'd8:seg = 7'b0000000;
                4'd9:seg = 7'b0010000;
                4'd10:seg = 7'b0001000;
                4'd11:seg = 7'b0000011;
                4'd12:seg = 7'b0100111;
                4'd13:seg = 7'b0100001;
                4'd14:seg = 7'b0000110;
                4'd15:seg = 7'b0001110;
            endcase
        else seg = 7'b1111111;
    
    always @(posedge clk_100M)
        begin
            if (cnt == 0)
                clk_500 <= 1;
            else 
                clk_500 <= 0;
            if (cnt < 199999)
                cnt <= cnt + 1;
            else 
                cnt <= 0;
        end
    
    always @(posedge clk_500) 
        begin
            if(address==3'd7) address=3'd0; 
            else address=address+1; 
            case(address)
                3'd0:if(Enable[0]) begin x <= bcdin0; en <= 1'b1;end 
                     else en = 1'b0;
                3'd1:if(Enable[1]) begin x <= bcdin1; en <= 1'b1;end 
                     else en = 1'b0;
                3'd2:if(Enable[2]) begin x <= bcdin2; en <= 1'b1;end 
                     else en = 1'b0;
                3'd3:if(Enable[3]) begin x <= bcdin3; en <= 1'b1;end 
                     else en = 1'b0;
                3'd4:if(Enable[4]) begin x <= bcdin4; en <= 1'b1;end 
                     else en = 1'b0;
                3'd5:if(Enable[5]) begin x <= bcdin5; en <= 1'b1;end 
                     else en = 1'b0;
                3'd6:if(Enable[6]) begin x <= bcdin6; en <= 1'b1;end 
                     else en = 1'b0;
                3'd7:if(Enable[7]) begin x <= bcdin7; en <= 1'b1;end 
                     else en = 1'b0;
            endcase 
        end

endmodule
