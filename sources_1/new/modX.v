module modX(value, carry, tick, upDown, clear, MOD, load);

    output reg [6:0] value;
    output reg carry;
    input [6:0] MOD;
    input tick, clear, upDown;
    input load;

    // counter
    always @(posedge tick or posedge clear) begin

        carry <= 1'b0;
        if (clear)
            value <= 0;

        else begin
            case(load)

                1'b0: begin
                    if(upDown) begin
                        if(value + 1 >= MOD)
                            value <= 0;
                        else
                            value <= value + 1;
                    end

                    else begin

                        if(! value)
                            value <= MOD - 1;
                        else
                            value <= value - 1;
                    end

                    carry <= upDown ? value == MOD - 1 : value == 0;
                end

                1'b1: begin
                    if(value + 1 >= MOD)
                        value <= 0;
                    else
                        value <= value + 1;
                end
            endcase
        end
    end

endmodule