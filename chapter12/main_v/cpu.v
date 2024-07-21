module cpu(
    input           clk,
    input           n_reset,
    input   [7:0]   data,
    input   [3:0]   switch,
    output  [3:0]   addr,
    output  [3:0]   led
);
    // register
    reg     [3:0]   r_out;
    reg     [3:0]   r_ip;       // 命令ポインタ
    reg             r_cf;       // キャリーフラグ
    reg     [3:0]   r_a;        // 汎用レジスタ(A)
    reg     [3:0]   r_b;        // 汎用レジスタ(B)

    // wire
    wire    [3:0]   w_next_out;
    wire    [3:0]   w_next_ip;  // 次回の命令ポインタ
    wire            w_next_cf;  // 次回のキャリーフラグ
    wire    [3:0]   w_next_a;   // 次回の汎用レジスタ(A)
    wire    [3:0]   w_next_b;   // 次回の汎用レジスタ(B)
    wire    [3:0]   w_opecode;  // opecode(命令)
    wire    [3:0]   w_imm;      // imm(即値)(LSB4bit)

    // ff
    always @(posedge clk or negedge n_reset) begin
        if (~n_reset) begin
            r_out   <= 4'b0000;
            r_ip    <= 4'b0000;
            r_cf    <= 1'b0;
            r_a     <= 4'b0000;
            r_b     <= 4'b0000;
        end
        else begin
            r_out   <= w_next_out;
            r_ip    <= w_next_ip;
            r_cf    <= w_next_cf;
            r_a     <= w_next_a;
            r_b     <= w_next_b;
        end
    end

    // operation
    assign {w_next_out,w_next_ip,w_next_cf,w_next_a,w_next_b} = opeset(w_opecode, w_imm, r_out, r_ip, r_cf, r_a, r_b);

    // opecode  - romからのDataMSB4bit
    // imm      - romからのDataLSB4bit
    assign {w_opecode, w_imm} = data;

    // operation set opeset = {out, ip, cf, a, b}
    function [17:0] opeset;
        input [3:0] opecode;
        input [3:0] imm;
        input [3:0] out;
        input [3:0] ip;
        
        input cf;
        input [3:0] a;
        input [3:0] b;

        reg [4:0] add_a;
        reg [4:0] add_b;

        begin

        add_a = a + imm;
        add_b = b + imm;

        case (opecode)
            4'b0000: opeset = {out, ip + 4'b0001,           add_a[4],   add_a[3:0], b};         // ADD A, IMM
            4'b0101: opeset = {out, ip + 4'b0001,           add_b[4],   a,          add_b[3:0]};// ADD B, IMM
            4'b0011: opeset = {out, ip + 4'b0001,           1'b0,       imm,        b};         // MOV A, IMM
            4'b0111: opeset = {out, ip + 4'b0001,           1'b0,       a,          imm};       // MOV B, IMM
            4'b0001: opeset = {out, ip + 4'b0001,           1'b0,       b,          b};         // MOV A, B
            4'b0100: opeset = {out, ip + 4'b0001,           1'b0,       a,          a};         // MOV B, A
            4'b1111: opeset = {out,   imm,                  1'b0,       a,          b};         // JMP IMM
            4'b1110: opeset = {out, cf ? ip + 4'd1 : imm,   1'b0,       a,          b};         // JNC IMM
            4'b0010: opeset = {out, ip + 4'b0001,           1'b0,       switch,     b};         // IN A
            4'b0110: opeset = {out, ip + 4'b0001,           1'b0,       a,          switch};    // IN B
            4'b1001: opeset = {b,   ip + 4'b0001,           1'b0,       a,          b};         // OUT B
            4'b1011: opeset = {imm, ip + 4'b0001,           1'b0,       a,          b};         // OUT IMM
            default: opeset = {out, ip + 4'b0001,           1'b0,       a,          b};         // デフォルトで次の命令ポインタに進みつつ、キャリーフラグは0
        endcase

        end

    endfunction



    // output
    assign addr = r_ip;
    assign led  = r_out;

endmodule