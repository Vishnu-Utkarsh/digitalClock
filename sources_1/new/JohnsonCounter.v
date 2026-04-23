module D_FF(Q, D, clk, rst);

    output reg Q = 0;
    input D, clk, rst;

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule

module Johnson(value, tick, reset);

    output [4:0] value;
    input tick, reset;
    assign feedback = ~value[4];

    D_FF A(value[0], feedback, tick, reset);
    D_FF B(value[1], value[0], tick, reset);
    D_FF C(value[2], value[1], tick, reset);
    D_FF D(value[3], value[2], tick, reset);
    D_FF E(value[4], value[3], tick, reset);
endmodule