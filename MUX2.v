module MUX2 #(parameter N = 32)(
    input [N-1:0] data0, data1,
    input s,
    output [N-1:0] out
    );
    
    assign out = (s) ? data1 : data0;
    
endmodule