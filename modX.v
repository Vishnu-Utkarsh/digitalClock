module modX(value, carry, tick_1Hz, clr, prst, MOD);

    output reg [5:0] value;
    output reg carry;
    input [5:0] MOD;
    input tick_1Hz, clr, prst;

    // counter
    always @(posedge tick_1Hz or posedge prst or posedge clr) begin

        if (clr) begin
            value = 0;
            carry = 1'b0;
        end

        else if (prst) begin
            value = MOD - 1;
        end

        else if (value == MOD) begin
            value = 0;
            carry = 1'b1;
        end

        else begin
            value = value + 1;

            if(value == MOD)
                value = 0;
            carry = ! value;
        end
    end
endmodule