module MUX3or4 #(parameter N = 32)(
    input [N-1:0] data0, data1, data2, data3,
    input [1:0] s,
    output reg [N-1:0] out
    );
    
    always @ (*)
        case(s)
            2'd0: out <= data0;
            2'd1: out <= data1;
            2'd2: out <= data2;
            2'd3: out <= data3;
        endcase
        
endmodule