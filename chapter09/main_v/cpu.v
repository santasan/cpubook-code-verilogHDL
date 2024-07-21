module cpu(
    input   clk,
    input   n_reset,
    output  led
);
    // register
    reg     r_led;

    // clk1サイクルごとに反転するled
    always @(posedge clk or negedge n_reset) begin
        if (~n_reset)   r_led <= 1'b0;
        else            r_led <= ~r_led;
    end

    assign led = r_led;

endmodule