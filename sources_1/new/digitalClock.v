module digitalClock (seg, an, light, format, alarmOut, currMode, clk, reset, toggleAlarm, showHour, speed, minus, plus, load, switch);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    output [6:0] seg;
    output [3:0] an;
    output [9:0] light;
    output format, alarmOut, currMode;

    input clk, reset, toggleAlarm, showHour, speed, minus, plus, load, switch;

    wire beep, beep1, beep2;
    wire [18:0] samay, timekeeper, chronometer;
    wire [10:0] alarm;
    reg tick = 1'b0;
    reg [1:0] state = S0, mode = S0;
    reg [31:0] freq = 32'd100000000, clock_div = 32'd0;

    assign beep = beep1 | beep2;
    assign alarmOut = toggleAlarm;

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
    alarm Alarm(alarm, beep1, reset, toggleAlarm, samay[17:7], minus, plus, state, mode);
    stopwatch Chrono(chronometer, clk, reset | load, freq, plus, mode);
    timer TickTick(timekeeper, beep2, clk, reset, freq, minus, plus, state, mode);
    display Show(seg, an, format, currMode, clk, showHour, state, mode, samay, alarm, chronometer, timekeeper);

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

    // ---------- LIGHTNING ----------
    Johnson left(light [9:5], tick, reset || (! beep));
    Johnson right(light [4:0], tick, reset || (! beep));

endmodule