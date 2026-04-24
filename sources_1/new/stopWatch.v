module stopwatch(value, clk, reset, freq, plus, mode);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    output [18:0] value;

    input clk, reset, plus;
    input [1:0] mode;
    input [31:0] freq;

    wire [2:0] clock_Carry;
    reg tick_1Hz = 1'b0, pause = 1'b1, plus_r;
    reg [31:0] clock_div = 0;

    // ---------- STOPWATCH ----------
    always @(posedge clk)
        plus_r <= plus;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            clock_div <= 0;
            tick_1Hz <= 0;
            pause <= 1'b1;
        end

        else begin
            if(mode == S2 && (plus & ~plus_r))
                pause <= ~ pause;

            if(! pause) begin
                // Clock 100 MHz to 0.01Hz
                if (clock_div >= freq) begin // d100000000
                    clock_div <= 0;
                    tick_1Hz <= 1;
                end
                else begin
                    tick_1Hz <= 0;
                    clock_div <= clock_div + 32'd100;
                end
            end
        end
    end

    // ---------- COUNTERS ----------
    modX centiSecond(value[6:0], clock_Carry[0], tick_1Hz, 1'b1, reset, 7'd100, 1'b0);
    modX second(value[12:7], clock_Carry[1], clock_Carry[0], 1'b1, reset, 7'd60, 1'b0);
    modX minute(value[18:13], clock_Carry[2], clock_Carry[1], 1'b1, reset, 7'd60, 1'b0);

endmodule