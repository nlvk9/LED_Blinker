`timescale 1us/1ns

module led_blink_tb;

  reg i_clock;
  reg i_switch_1;
  reg i_switch_2;
  reg i_enable;

  wire o_led_state;

  led_blink #(
    .frequency_100HZ(5),
    .frequency_50HZ(10),
    .frequency_10HZ(20),
    .frequency_1HZ(40)
  ) uut (
    .i_clock(i_clock),
    .i_switch_1(i_switch_1),
    .i_switch_2(i_switch_2),
    .i_enable(i_enable),
    .o_led_state(o_led_state)
  );

  // 🔥 ADD THIS
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, led_blink_tb);
  end

  // clock
  initial begin
    i_clock = 0;
    forever #10 i_clock = ~i_clock;
  end

  // stimulus
  initial begin
    i_switch_1 = 0;
    i_switch_2 = 0;
    i_enable   = 0;

    #50;
    i_enable = 1;

    i_switch_1 = 0; i_switch_2 = 0;
    #1000;

    i_switch_1 = 0; i_switch_2 = 1;
    #1000;

    i_switch_1 = 1; i_switch_2 = 0;
    #1000;

    i_switch_1 = 1; i_switch_2 = 1;
    #1000;

    i_enable = 0;
    #500;

    $finish; // better than $stop for EPWave
  end

endmodule
