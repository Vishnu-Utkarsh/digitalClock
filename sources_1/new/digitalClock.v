module digitalClock (format, state, seg, an, clk, count, clear, preset, upDown, showHour, speed, next, load, back);

    // Output
    output reg [7:0] seg;
    output reg [3:0] an;
    wire [16:0] Q;
    reg [3:0] digit;
    output reg format;
    input showHour;

    // system clock
    reg tick_1Hz = 1'b0;
    reg [2:0] set = 1'b0;
    reg [31:0] clkdiv = 0, freq = 32'd50000000;
    wire [3:0] carry;
    input clk, count, clear, preset, upDown, speed;

    // Load
    input next, load, back;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    reg load_r, next_r, back_r;
    output reg [1:0] state = S0;
    reg change = 0;

    always @(posedge speed) begin
        freq = freq / 10;

        if(freq < 32'd50000)
            freq = 32'd50000000;
    end

    // Clock 100 MHz to 1Hz
    always @(posedge clk) begin

        set = 0;
        change = 0;
        load_r <= load;
        next_r <= next;
        back_r <= back;

        if (preset || clear) begin
            clkdiv <= 0;
            tick_1Hz <= 0;
        end

        else begin
        case(state)

            // Counter
            2'b00: begin
                if (clkdiv >= freq) begin // d50000000
                    clkdiv <= 0;
                    tick_1Hz <= ~ tick_1Hz;
                end
                else if(count)
                    clkdiv <= clkdiv + 1;
            end

            // Load Hour
            2'b01: begin

                if(next & ~next_r) begin
                    change = 1'b1;
                    set = 3'b100;
                end
                clkdiv <= 0;
            end

            // Load Minute
            2'b10: begin

                if(next & ~next_r) begin
                    change = 1'b1;
                    set = 3'b010;
                end
                clkdiv <= 0;
            end

            // Load Second
            2'b11: begin

                if(next & ~next_r) begin
                    change = 1'b1;
                    set = 3'b001;
                end
                clkdiv <= 0;
            end
        endcase

        if(load & ~load_r)
            state = state + 1;
        if(state && (back & ~back_r))
            state = state - 1;
        end
    end

    //Display clock divider
    reg [24:0] refresh_counter = 0;
    wire [1:0] select;
    assign select = refresh_counter[16:15];

    // assign carry[1] = upDown ? Q[5:0] == 6'd59 : Q[5:0] == 6'd0;
    // assign carry[2] = upDown ? Q[11:6] == 6'd59 : Q[11:6] == 6'd0;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    modX second(Q[5:0], carry[0], tick_1Hz | set[0], 1'b1, clear, preset, 6'd60, change);
    modX minute(Q[11:6], carry[1], carry[0] | set[1], 1'b1, clear, preset, 6'd60, change);
    modX hour(Q[16:12], carry[2], carry[1] | set[2], 1'b1, clear, preset, 6'd24, change);

    always @(*) begin
        // format = (Q[16:12] != 5'd0) || showHour;
        format = showHour;

        case (state)

            S0: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        if(format)
                            digit = Q[11:6] % 10;
                        else
                            digit = Q[5:0] % 10;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        if(format)
                            digit = Q[11:6] / 10;
                        else
                            digit = Q[5:0] / 10;
                    end

                    2'b10: begin
                        an = 4'b1011;
                        if(format)
                            digit = Q[16:12] % 10;
                        else
                            digit = 4'hA;
                    end

                    2'b11: begin
                        an = 4'b0111;
                        if(format)
                            digit = Q[16:12] / 10;
                        else
                            digit = 4'hA;
                    end
                endcase
            end

            S1: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        digit = Q[11:6] % 10;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        digit = Q[11:6] / 10;
                    end

                    2'b10: begin
                        an = 4'b1011;
                        if(refresh_counter[24])
                            digit = Q[16:12] % 10;
                        else
                            digit = 4'hF;
                    end

                    2'b11: begin
                        an = 4'b0111;
                        if(refresh_counter[24])
                            digit = Q[16:12] / 10;
                        else
                            digit = 4'hF;
                    end
                endcase
            end

            S2: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        if(refresh_counter[24])
                            digit = Q[11:6] % 10;
                        else
                            digit = 4'hF;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        if(refresh_counter[24])
                            digit = Q[11:6] / 10;
                        else
                            digit = 4'hF;
                    end

                    2'b10: begin
                        an = 4'b1011;
                        digit = Q[16:12] % 10;
                    end

                    2'b11: begin
                        an = 4'b0111;
                        digit = Q[16:12] / 10;
                    end
                endcase
            end

            S3: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        if(refresh_counter[24])
                            digit = Q[5:0] % 10;
                        else
                            digit = 4'hF;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        if(refresh_counter[24])
                            digit = Q[5:0] / 10;
                        else
                            digit = 4'hF;
                    end

                    default: begin
                        an = 4'b0011;
                        digit = 4'hA;
                    end
                endcase
            end
        endcase
    end

    // 7 segment decoder
    always @(*) begin
        case(digit)
            4'd0 : seg = 8'b10000001;   // 0
            4'd1 : seg = 8'b11001111;   // 1
            4'd2 : seg = 8'b10010010;   // 2
            4'd3 : seg = 8'b10000110;   // 3
            4'd4 : seg = 8'b11001100;   // 4
            4'd5 : seg = 8'b10100100;   // 5
            4'd6 : seg = 8'b10100000;   // 6
            4'd7 : seg = 8'b10001111;   // 7
            4'd8 : seg = 8'b10000000;   // 8
            4'd9 : seg = 8'b10000100;   // 9
            4'hA : seg = 8'b11111111;   // @
            default: seg = 8'b11111110; // -
        endcase
    end
endmodule