module mother_board (
    input   clk,
    input   n_reset,
    output  led
);
    // wire 
    wire    data;
    wire    addr;

    // cpu
    cpu cpu(
        .clk    (clk),
        .n_reset(n_reset),
        .data   (data),
        .addr   (addr),
        .led    (led)
    );

    assign data = rom(addr);

    // function ROM
    function rom;
        input addr;
        begin
            case (addr)
                1'b0: rom = 1'b1;   // NOT
                1'b1: rom = 1'b0;   // NOP
            endcase
        end
    endfunction

endmodule