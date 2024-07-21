module top (
    input   pin_clock,
    input   pin_n_reset,
    output  pin_led
);

    // wire
    wire    clk;

    // register
    reg     r_pin_n_reset;

    // prescaler 100MHz->1MHz
    prescaler #(.RATIO(100)) prescaler(
        .quick_clock    (pin_clock),
        .n_reset        (pin_n_reset),
        .slow_clock     (clk)
    );

    // cpu
    cpu cpu(
        .clk        (clk),
        .n_reset    (pin_n_reset),
        .led        (pin_led)
    );

endmodule //top