module prescaler
#(
    parameter   RATIO = 2
)
(
    input   quick_clock,
    input   n_reset,
    output  slow_clock
);
    // wire
    wire    [31:0]  w_next_counter;     // 次のクロックでのカウンタの値

    // register
    reg     [31:0]  r_counter;          // カウンタ。RATIOはたかだか2^32程度と想定
    reg             r_slow_clock;       // 出力するクロックのFF

    // counter
    always @(posedge quick_clock or negedge n_reset) begin
        if (~n_reset)begin
            r_counter <= 32'h0;
        end
        else if (w_next_counter == RATIO) begin
            r_counter <= 32'h0;
        end
        else begin
            r_counter <= r_counter + 1'b1;
        end
    end

    // slow clock
    always @(posedge quick_clock or negedge n_reset) begin
        if (~n_reset) begin
            r_slow_clock <= 1'b0;
        end
        else if (w_next_counter == RATIO) begin
            r_slow_clock <= ~r_slow_clock;
        end
        else begin
            r_slow_clock <= r_slow_clock;
        end
    end

    // next_counter
    assign w_next_counter = r_counter + 1'b1;

    // output
    assign slow_clock = r_slow_clock;


endmodule
