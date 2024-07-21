module top (
    input        pin_clock,
    input        pin_n_reset,
    input  [3:0] pin_switch,
    output [3:0] pin_led
);

    // wire
    wire    clk;

    // prescaler 100MHz->10MHz
    prescaler #(.RATIO(10)) prescaler(
        .quick_clock    (pin_clock),
        .n_reset        (pin_n_reset),
        .slow_clock     (clk)
    );

    // mpther_board
    mother_board mother_board(
        .clk        (clk),
        .n_reset    (pin_n_reset),
        .pin_switch (pin_switch),
        .pin_led    (pin_led)
    );

endmodule //top