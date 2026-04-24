module alarm(value, beep, reset, toggleAlarm, samay, minus, plus, state, mode);

    // ---------- VARIABLES ----------
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    output reg [10:0] value = 0;
    output reg beep = 1'b0;

    input reset, toggleAlarm, minus, plus;
    input [1:0] state, mode;
    input [10:0] samay;

    reg pause = 1'b0;

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
    always @(*) begin

        if(reset || (mode == S1 && state)) begin
            pause <= 1'b0;
            beep <= 1'b0;
        end
        else if(plus) begin
            pause = 1'b1;
            beep = 1'b0;
        end
        else if(value != samay) begin
            pause = 1'b0;
            beep = 1'b0;
        end
        else
            beep = toggleAlarm & (! pause);    
    end

endmodule