module stopwatch(value, clk, reset, freq, plus, mode);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    output [16:0] value;

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
                // Clock 100 MHz to 1Hz
                if (clock_div >= freq) begin // d100000000
                    clock_div <= 0;
                    tick_1Hz <= 1;
                end
                else begin
                    tick_1Hz <= 0;
                    clock_div <= clock_div + 1;
                end
            end
        end
    end

    // ---------- COUNTERS ----------
    modX second(value[5:0], clock_Carry[0], tick_1Hz, 1'b1, reset, 6'd60, 1'b0);
    modX minute(value[11:6], clock_Carry[1], clock_Carry[0], 1'b1, reset, 6'd60, 1'b0);
    modX hour(value[16:12], clock_Carry[2], clock_Carry[1], 1'b1, reset, 6'd24, 1'b0);

endmodule