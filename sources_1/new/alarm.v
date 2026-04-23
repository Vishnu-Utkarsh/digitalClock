module alarm(value, beep, reset, samay, minus, plus, state, mode);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    output reg [10:0] value = 0;
    output reg beep = 1'b0;

    input reset, minus, plus;
    input [1:0] state, mode;
    input [10:0] samay;

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
    always @(posedge samay[0] or posedge plus or posedge reset) begin

        if(reset || plus)
            beep <= 1'b0;
        if(plus)
            beep <= 1'b0;
        else if(value && value == samay)
            beep <= 1'b1;
        else
            beep <= 1'b0;
    end

endmodule