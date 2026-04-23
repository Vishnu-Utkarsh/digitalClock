module alarm(value, sound, clk, reset, samay, minus, plus, state, mode);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    output reg [10:0] value = 0;
    output [9:0] sound;
    reg alarm;

    input clk, reset, minus, plus;
    input [1:0] state, mode;
    input [10:0] samay;

    reg tick = 1'b0;
    reg [31:0] clock_div = 0;
    reg plus_r;


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

    // ---------- SET ALARM ----------
    always @(posedge reset or posedge plus) begin

        if (reset)
            value <= 0;

        else if(mode == S1) begin
            case(state)

                S1: begin
                    if(value[10:6] >= 5'd23)
                        value[10:6] <= 5'd0;
                    else
                        value [10:6] <= value [10:6] + 1;
                end

                S2: begin
                    if(value[5:0] >= 6'd59)
                        value[5:0] <= 6'd0;
                    else
                        value [5:0] <= value [5:0] + 1;
                end
            endcase
        end
    end

    // ---------- ALARM BEEP ----------
    always @(posedge samay[0] or posedge plus) begin

        if(plus)
            alarm <= 1'b0;
        else if(value && value == samay)
            alarm <= 1'b1;
        else
            alarm <= 1'b0;
    end

    Johnson left(sound [9:5], tick, reset | !alarm);
    Johnson right(sound [4:0], tick, reset | !alarm);

endmodule