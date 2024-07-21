module top (
    input   pin_clock,
    input   pin_n_reset,
    output  pin_led
);

    // wire
    wire    clk;

    // prescaler 100MHz->1MHz
    prescaler #(.RATIO(100)) prescaler(
        .quick_clock    (pin_clock),
        .n_reset        (pin_n_reset),
        .slow_clock     (clk)
    );

    // mpther_board
    mother_board mother_board(
        .clk        (clk),
        .n_reset    (pin_n_reset),
        .led        (pin_led)
    );

endmodule //top