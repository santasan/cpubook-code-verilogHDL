module mother_board (
    input   clk,
    input   n_reset,
    input  [3:0] pin_switch,
    output [3:0] pin_led
);
    // wire
    wire    [7:0] data;
    wire    [3:0] addr;

    // cpu
    cpu cpu(
        .clk    (clk),
        .n_reset(n_reset),
        .data   (data),
        .switch (pin_switch),
        .addr   (addr),
        .led    (pin_led)
    );

    assign data = rom(addr);

    // function ROM
    function [7:0] rom;
        input [3:0] addr;
        begin
            case (addr)                         // addr data    assembler
                4'b0000: rom = 8'b0110_0000;   // 0    8'h60   IN B
                4'b0001: rom = 8'b1001_0000;   // 1    8'h90   OUT B
                4'b0010: rom = 8'b0011_1101;   // 2    8'h3D   MOV A, 13
                4'b0011: rom = 8'b0000_0001;   // 3    8'h01   ADD A, 1
                4'b0100: rom = 8'b1110_0011;   // 4    8'hE3   JNC    3
                4'b0101: rom = 8'b0101_0001;   // 5    8'h51   ADD B, 1
                4'b0110: rom = 8'b1110_0001;   // 6    8'hE1   JNC    1
                4'b0111: rom = 8'b1011_0000;   // 7    8'hB0   OUT    0
                4'b1000: rom = 8'b1011_1111;   // 8    8'hBF   OUT    15
                4'b1001: rom = 8'b1111_0111;   // 9    8'hF7   JMP    7
                default: rom = 8'b0000_0000;
            endcase
        end
    endfunction

endmodule