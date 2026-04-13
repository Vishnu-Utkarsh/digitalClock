module digitalClock (seg, an, clk, count, clear, preset, speed);
    output reg [7:0] seg;
    output reg [3:0] an;
    wire [16:0] Q;
    reg [3:0] digit;

    reg tick_1Hz = 1'b0;
    reg [31:0] clkdiv = 0, freq = 32'd50000000;
    input clk, count, clear, preset, speed;
    wire [3:0] carry;

    always @(posedge speed) begin
        freq = freq / 10;

        if(freq < 32'd50000)
            freq = 32'd50000000;
    end

    // Clock 100 MHz to 1Hz
    always @(posedge clk or posedge preset or posedge clear) begin

        if (preset || clear) begin
            clkdiv <= 0;
            tick_1Hz <= 0;
        end

        else if (clkdiv >= freq) begin // d50000000
            clkdiv <= 0;
            tick_1Hz <= ~tick_1Hz;
        end

        else if(count)
            clkdiv <= clkdiv + 1;
    end

    //Display clock divider
    reg [15:0] refresh_counter = 0;
    wire [1:0] select;
    assign select = refresh_counter[14:13];

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    modX second(Q[5:0], carry[0], tick_1Hz, clear, preset, 6'd60);
    modX minute(Q[11:6], carry[1], carry[0], clear, preset, 6'd60);
    modX hour(Q[16:12], carry[2], carry[1], clear, preset, 6'd24);

    always @(*) begin
        case(select)

            2'b00: begin
                an = 4'b1110;
                if(Q[16:12])
                    digit = Q[11:6] % 10;
                else
                    digit = Q[5:0] % 10;
            end

            2'b01: begin
                an = 4'b1101;
                if(Q[16:12])
                    digit = Q[11:6] / 10;
                else
                    digit = Q[5:0] / 10;
            end

            2'b10: begin
                an = 4'b1011;
                if(Q[16:12])
                    digit = Q[16:12] % 10;
                else
                    digit = Q[11:6] % 10;
            end

            2'b11: begin
                an = 4'b0111;
                if(Q[16:12])
                    digit = Q[16:12] / 10;
                else
                    digit = Q[11:6] / 10;
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
            4'd10 : seg = 8'b10001000;  // A
            4'd11 : seg = 8'b11100000;  // b
            4'd12 : seg = 8'b10110001;  // C
            4'd13 : seg = 8'b11000010;  // d
            4'd14 : seg = 8'b10110000;  // E
            4'd15 : seg = 8'b10111000;  // F
            default: seg = 8'b11111110; // -
        endcase
    end
endmodule