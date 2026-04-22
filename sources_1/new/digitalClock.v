module digitalClock (format, seg, an, clk, reset, showHour, speed, plus, load, switch);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    output reg [6:0] seg;
    output reg [3:0] an;
    output reg format;
    reg [3:0] digit, display;

    input clk, reset, speed;
    input plus, load, switch, showHour;

    wire [1:0] state;
    wire [16:0] samay;
    reg [2:0] mode = S0;
    reg [31:0] freq = 32'd100000000;


    // ---------- SPEED ----------
    always @(posedge speed) begin
        freq = freq / 10;

        if(freq < 32'd100000)
            freq = 32'd100000000;
    end

    // ---------- CLOCK ----------
    clock Time(samay, state, clk, reset, freq, plus, load);


    // ---------- DISPLAY ----------
    reg [24:0] refresh_counter = 0;
    wire [1:0] select;
    assign select = refresh_counter[18:17];

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    always @(*) begin
        // format = (samay[16:12] != 5'd0) || showHour;
        format = showHour;

        case (state)

            S0: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        if(format)
                            digit = samay[11:6] % 10;
                        else
                            digit = samay[5:0] % 10;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        if(format)
                            digit = samay[11:6] / 10;
                        else
                            digit = samay[5:0] / 10;
                    end

                    2'b10: begin
                        an = 4'b1011;
                        if(format)
                            digit = samay[16:12] % 10;
                        else
                            digit = 4'hA;
                    end

                    2'b11: begin
                        an = 4'b0111;
                        if(format)
                            digit = samay[16:12] / 10;
                        else
                            digit = 4'hA;
                    end
                endcase
            end

            S1: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        digit = samay[11:6] % 10;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        digit = samay[11:6] / 10;
                    end

                    2'b10: begin
                        an = 4'b1011;
                        if(refresh_counter[24])
                            digit = samay[16:12] % 10;
                        else
                            digit = 4'hF;
                    end

                    2'b11: begin
                        an = 4'b0111;
                        if(refresh_counter[24])
                            digit = samay[16:12] / 10;
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
                            digit = samay[11:6] % 10;
                        else
                            digit = 4'hF;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        if(refresh_counter[24])
                            digit = samay[11:6] / 10;
                        else
                            digit = 4'hF;
                    end

                    2'b10: begin
                        an = 4'b1011;
                        digit = samay[16:12] % 10;
                    end

                    2'b11: begin
                        an = 4'b0111;
                        digit = samay[16:12] / 10;
                    end
                endcase
            end

            S3: begin
                case(select)

                    2'b00: begin
                        an = 4'b1110;
                        if(refresh_counter[24])
                            digit = samay[5:0] % 10;
                        else
                            digit = 4'hF;
                    end

                    2'b01: begin
                        an = 4'b1101;
                        if(refresh_counter[24])
                            digit = samay[5:0] / 10;
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

    // ---------- 7 SEGMENT DECODER ----------
    always @(*) begin
        case(digit)
            4'd0 : seg = 7'b0000001;   // 0
            4'd1 : seg = 7'b1001111;   // 1
            4'd2 : seg = 7'b0010010;   // 2
            4'd3 : seg = 7'b0000110;   // 3
            4'd4 : seg = 7'b1001100;   // 4
            4'd5 : seg = 7'b0100100;   // 5
            4'd6 : seg = 7'b0100000;   // 6
            4'd7 : seg = 7'b0001111;   // 7
            4'd8 : seg = 7'b0000000;   // 8
            4'd9 : seg = 7'b0000100;   // 9
            4'hA : seg = 7'b1111111;   // @
            default: seg = 7'b1111110; // -
        endcase
    end
endmodule