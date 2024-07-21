module cpu(
    input   clk,
    input   n_reset,
    input   data,
    output  addr,
    output  led
);
    // register
    reg     r_led;
    reg     r_ip;       // 命令ポインタ

    // dataの指示に従って、論理を反転するled
    always @(posedge clk or negedge n_reset) begin
        if (~n_reset)           r_led <= 1'b0;
        else if (data == 1'b0)  r_led <= r_led;     // NOP
        else if (data == 1'b1)  r_led <= ~r_led;    // NOT
    end

    // address = 1'b0から順番に命令ポインタを変更
    always @(posedge clk or negedge n_reset) begin
        if (~n_reset)   r_ip <= 1'b0;
        else            r_ip <= r_ip + 1'b1;
    end

    assign led  = r_led;
    assign addr = r_ip;

endmodule