module modX(value, carry, tick_1Hz, upDown, clr, prst, MOD, load);

    output reg [5:0] value;
    output reg carry;
    input [5:0] MOD;
    input tick_1Hz, clr, prst, upDown;
    input load;

    // counter
    always @(posedge tick_1Hz or posedge prst or posedge clr) begin

        carry <= 1'b0;
        if (clr)
            value <= 0;

        else if (prst)
            value <= MOD - 1;

        else begin
            case(load)

                1'b0: begin
                    if(upDown) begin
                        if(value + 1 >= MOD)
                            value <= 0;
                        else
                            value <= value + 1;
                        // carry <= ! value;
                    end
                    else begin
                        // carry <= ! value;

                        if(! value)
                            value <= MOD - 1;
                        else
                            value <= value - 1;
                    end

                    carry <= upDown ? value == 6'd59 : value == 6'd0;
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