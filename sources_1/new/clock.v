module clock(value, clk, reset, freq, plus, state, mode);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    output [18:0] value;

    input clk, reset, plus;
    input [1:0] state, mode;
    input [31:0] freq;

    wire [2:0] clock_Carry;
    reg tick_1Hz = 1'b0, change = 1'b0, plus_r;
    reg [2:0] set = 0;
    reg [31:0] clock_div = 0;

    // ---------- CLOCK ----------
    always @(posedge clk) begin

        plus_r <= plus;

        if (reset) begin
            clock_div <= 0;
            tick_1Hz <= 0;
            change <= 0;
            set <= 0;
        end

        // Clock 100 MHz to 1Hz
        else if(mode != S0) begin

            if (clock_div >= freq) begin // d100000000
                clock_div <= 0;
                tick_1Hz <= 1;
            end
            else begin
                tick_1Hz <= 0;
                clock_div <= clock_div + 1;
            end

            change <= 0;
            set <= 0;
        end

        else begin
            case(state)

                // Clock 100 MHz to 1Hz
                S0: begin

                    if (clock_div >= freq) begin // d100000000
                        clock_div <= 0;
                        tick_1Hz <= 1;
                    end
                    else begin
                        tick_1Hz <= 0;
                        clock_div <= clock_div + 1;
                    end

                    change <= 0;
                    set <= 0;
                end

                // Load Hour
                S1: begin

                    if(plus & ~plus_r) begin
                        change <= 1'b1;
                        set <= 3'b100;
                    end
                    else begin
                        change <= 0;
                        set <= 0;
                    end
                    clock_div <= 0;
                end

                // Load Minute
                S2: begin

                    if(plus & ~plus_r) begin
                        change <= 1'b1;
                        set <= 3'b010;
                    end
                    else begin
                        change <= 0;
                        set <= 0;
                    end
                    clock_div <= 0;
                end

                // Load Second
                S3: begin

                    if(plus & ~plus_r) begin
                        change <= 1'b1;
                        set <= 3'b001;
                    end
                    else begin
                        change <= 0;
                        set <= 0;
                    end
                    clock_div <= 0;
                end
            endcase
        end
    end


    // ---------- COUNTERS ----------
    modX second(value[6:0], clock_Carry[0], tick_1Hz | set[0], 1'b1, reset, 7'd60, change);
    modX minute(value[12:7], clock_Carry[1], clock_Carry[0] | set[1], 1'b1, reset, 7'd60, change);
    modX hour(value[18:13], clock_Carry[2], clock_Carry[1] | set[2], 1'b1, reset, 7'd24, change);

endmodule