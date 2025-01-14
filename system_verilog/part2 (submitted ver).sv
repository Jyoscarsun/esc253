module RateDivider
#(parameter CLOCK_FREQUENCY = 500) (
    input logic ClockIn,
    input logic Reset,
    input logic [1:0] Speed,
    output logic Enable);

    logic [11:0] RateDividerCount;
    logic [11:0] counter; 

    always_comb begin
        case(Speed)
        2'b00: RateDividerCount = 0;
        2'b01: RateDividerCount = CLOCK_FREQUENCY - 1;
        2'b10: RateDividerCount = (CLOCK_FREQUENCY * 2) - 1;
        2'b11: RateDividerCount = (CLOCK_FREQUENCY * 4) - 1;
        default: RateDividerCount = CLOCK_FREQUENCY;
        endcase
    end

    always_ff @(posedge ClockIn)
    begin
        if(Reset) counter <= RateDividerCount;
        else
            if(counter == 0) counter <= RateDividerCount;
            else counter <= counter - 1;
    end

    assign Enable = (counter == 'b0)?'1:'0;
endmodule

module DisplayCounter (
    input logic Clock,
    input logic Reset,
    input logic EnableDC,
    output logic [3:0] CounterValue
);
    always_ff @(posedge Clock)
    begin
        if(Reset) CounterValue <= 4'b0000;
        else
            if(EnableDC) CounterValue <= CounterValue + 1;
    end
endmodule

module part2
#(parameter CLOCK_FREQUENCY = 500)(
    input logic ClockIn,
    input logic Reset,
    input logic [1:0] Speed,
    output logic [3:0] CounterValue
);
    logic w;
    RateDivider u0(
        .ClockIn(ClockIn),
        .Reset(Reset),
        .Speed(Speed),
        .Enable(w)
    );

    DisplayCounter u1(
        .Clock(ClockIn),
        .Reset(Reset),
        .EnableDC(w),
        .CounterValue(CounterValue)
    );
endmodule