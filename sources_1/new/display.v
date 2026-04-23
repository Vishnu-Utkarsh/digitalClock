module display(seg, an, format, currMode, clk, showHour, state, mode, samay, alarm, chronometer);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    output reg [6:0] seg;
    output reg [3:0] an;
    output reg format, currMode;

    input clk, showHour;
    input [1:0] state, mode;
    input [16:0] samay, chronometer;
    input [10:0] alarm;

    reg [3:0] digit;
    reg [16:0] display;
    reg [24:0] refresh_counter = 0;
    wire [1:0] select;
    assign select = refresh_counter[18:17];

    // ---------- DISPLAY ----------
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    always @(*) begin
        format = showHour || mode == S1;

        case (mode)

            S0: display = samay;
            S1: display[16:6] = alarm;
            S2: display = chronometer;
            default display = samay;
        endcase

        case (state)

            S0: begin
                case(select)

                    S0: begin
                        an = 4'b1110;
                        currMode = ! (mode == S0);
                        if(format)
                            digit = display[11:6] % 10;
                        else
                            digit = display[5:0] % 10;
                    end

                    S1: begin
                        an = 4'b1101;
                        currMode = ! (mode == S1);
                        if(format)
                            digit = display[11:6] / 10;
                        else
                            digit = display[5:0] / 10;
                    end

                    S2: begin
                        an = 4'b1011;
                        currMode = ! (mode == S2);
                        if(format)
                            digit = display[16:12] % 10;
                        else
                            digit = 4'hA;
                    end

                    S3: begin
                        an = 4'b0111;
                        currMode = ! (mode == S3);
                        if(format)
                            digit = display[16:12] / 10;
                        else
                            digit = 4'hA;
                    end
                endcase
            end

            S1: begin
                case(select)

                    S0: begin
                        an = 4'b1110;
                        currMode = ! (mode == S0);
                        digit = display[11:6] % 10;
                    end

                    S1: begin
                        an = 4'b1101;
                        currMode = ! (mode == S1);
                        digit = display[11:6] / 10;
                    end

                    S2: begin
                        an = 4'b1011;
                        currMode = ! (mode == S2);
                        if(refresh_counter[24])
                            digit = display[16:12] % 10;
                        else
                            digit = 4'hF;
                    end

                    S3: begin
                        an = 4'b0111;
                        currMode = ! (mode == S3);
                        if(refresh_counter[24])
                            digit = display[16:12] / 10;
                        else
                            digit = 4'hF;
                    end
                endcase
            end

            S2: begin
                case(select)

                    S0: begin
                        an = 4'b1110;
                        currMode = ! (mode == S0);
                        if(refresh_counter[24])
                            digit = display[11:6] % 10;
                        else
                            digit = 4'hF;
                    end

                    S1: begin
                        an = 4'b1101;
                        currMode = ! (mode == S1);
                        if(refresh_counter[24])
                            digit = display[11:6] / 10;
                        else
                            digit = 4'hF;
                    end

                    S2: begin
                        an = 4'b1011;
                        currMode = ! (mode == S2);
                        digit = display[16:12] % 10;
                    end

                    S3: begin
                        an = 4'b0111;
                        currMode = ! (mode == S3);
                        digit = display[16:12] / 10;
                    end
                endcase
            end

            S3: begin
                case(select)

                    S0: begin
                        an = 4'b1110;
                        currMode = ! (mode == S0);
                        if(refresh_counter[24])
                            digit = display[5:0] % 10;
                        else
                            digit = 4'hF;
                    end

                    S1: begin
                        an = 4'b1101;
                        currMode = ! (mode == S1);
                        if(refresh_counter[24])
                            digit = display[5:0] / 10;
                        else
                            digit = 4'hF;
                    end

                    S2: begin
                        an = 4'b1011;
                        currMode = ! (mode == S2);
                        digit = 4'hA;
                    end

                    S3: begin
                        an = 4'b0111;
                        currMode = ! (mode == S3);
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