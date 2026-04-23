module digitalClock (seg, an, light, format, currMode, clk, reset, showHour, speed, minus, plus, load, switch);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    output [6:0] seg;
    output [3:0] an;
    output [9:0] light;
    output format, currMode;

    input clk, reset, showHour, speed, minus, plus, load, switch;

    wire beep;
    wire [16:0] samay, chronometer;
    wire [10:0] alarm;
    reg tick = 1'b0;
    reg [1:0] state = S0, mode = S0;
    reg [31:0] freq = 32'd100000000, clock_div = 32'd0;

    // ---------- MODE ----------
    always @(posedge switch)
        mode <= mode + 1;
    always @(posedge load or posedge switch) begin
        if(switch)
            state <= S0;
        else if(mode == S1 && state == S2)
            state <= S0;
        else if(mode != S2)
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
    alarm Alarm(alarm, beep, reset, samay[16:6], minus, plus, state, mode);
    stopwatch chrono(chronometer, clk, reset, freq, plus, mode);
    display show(seg, an, format, currMode, clk, showHour, state, mode, samay, alarm, chronometer);

    // ---------- 0.5 Hz Divider ----------
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            clock_div <= 0;
            tick <= 0;
        end
        else if (clock_div >= 32'd50000000) begin
            clock_div <= 0;
            tick <= 1;
        end
        else begin
            tick <= 0;
            clock_div <= clock_div + 1;
        end
    end

    Johnson left(light [9:5], tick, reset || (! beep));
    Johnson right(light [4:0], tick, reset || (! beep));

endmodule