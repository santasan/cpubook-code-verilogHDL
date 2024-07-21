`timescale 1ns/1ps
module test_top();
    logic pin_clock;
    logic pin_n_reset;
    logic pin_led;

    top top(
        .pin_clock      (pin_clock),
        .pin_led        (pin_led),
        .pin_n_reset    (pin_n_reset)
    );

  initial   pin_clock = 1'b0;
  always #5 pin_clock = ~pin_clock;

  initial begin
    pin_n_reset = 1'b0;
    #10;
    pin_n_reset = 1'b1;
  end

  initial begin
    #20000;
    $finish();
  end
endmodule
