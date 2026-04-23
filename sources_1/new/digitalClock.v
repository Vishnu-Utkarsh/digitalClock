module digitalClock (seg, an, sound, format, currMode, clk, reset, showHour, speed, minus, plus, load, switch);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    output [6:0] seg;
    output [3:0] an;
    output [9:0] sound;
    output format, currMode;

    input clk, reset, showHour, speed, minus, plus, load, switch;

    wire [16:0] samay;
    wire [10:0] alarm;
    reg [1:0] state = S0, mode = S0;
    reg [31:0] freq = 32'd100000000;

    // ---------- MODE ----------
    always @(posedge switch)
        mode <= mode + 1;
    always @(posedge load or posedge switch) begin
        if(switch)
            state <= S0;
        else if(mode == S1 && state == S2)
            state <= S0;
        else
            state <= state + 1;
    end

    // ---------- SPEED ----------
    always @(posedge speed) begin
        freq = freq / 10;

        if(freq < 32'd100000)
            freq = 32'd100000000;
    end

    // ---------- OBJECTS ----------
    clock Time(samay, clk, reset, freq, minus, plus, state, mode);
    alarm Beep(alarm, sound, clk, reset, samay[16:6], minus, plus, state, mode);
    display show(seg, an, format, currMode, clk, showHour, state, mode, samay, alarm);

endmodule