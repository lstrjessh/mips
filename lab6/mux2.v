// 2-to-1 Multiplexer
module mux2 #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in0,
    input  [WIDTH-1:0] in1,
    input              sel, // select signal
    output [WIDTH-1:0] out // output
);
    assign out = sel ? in1 : in0; // if sel is 1, output in1; else output in0
endmodule
