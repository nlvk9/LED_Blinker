`timescale 1us/1ns  // sets time unit and precision for simulation timing

module led_blink_tb;  // testbench for led_blink module

  reg i_clock;        // simulated clock signal
  reg i_switch_1;     // switch input 1
  reg i_switch_2;     // switch input 2
  reg i_enable;       // enable signal for output control

  wire o_led_state;   // output from dut (led state)

  // instantiate the device under test (dut) with faster test frequencies
  led_blink #(
    .frequency_100HZ(5),   // scaled down for simulation
    .frequency_50HZ(10),   // scaled down for simulation
    .frequency_10HZ(20),   // scaled down for simulation
    .frequency_1HZ(40)     // scaled down for simulation
  ) uut (
    .i_clock(i_clock),
    .i_switch_1(i_switch_1),
    .i_switch_2(i_switch_2),
    .i_enable(i_enable),
    .o_led_state(o_led_state)
  );

  // generate waveform dump file for viewing in epwave/gtkwave
  initial begin
    $dumpfile("dump.vcd");   // creates waveform file
    $dumpvars(0, led_blink_tb); // dumps all signals in this module
  end

  // clock generation (creates repeating 20us period clock)
  initial begin
    i_clock = 0;             // start clock low
    forever #10 i_clock = ~i_clock; // toggle every 10us
  end

  // stimulus generation (drives inputs over time)
  initial begin
    i_switch_1 = 0;   // default switch state
    i_switch_2 = 0;   // default switch state
    i_enable   = 0;   // start disabled

    #50;              // wait before enabling
    i_enable = 1;     // turn system on

    i_switch_1 = 0; i_switch_2 = 0; // mode 0 (slowest)
    #1000;            // observe output

    i_switch_1 = 0; i_switch_2 = 1; // mode 1
    #1000;            // observe output

    i_switch_1 = 1; i_switch_2 = 0; // mode 2
    #1000;            // observe output

    i_switch_1 = 1; i_switch_2 = 1; // mode 3 (fastest)
    #1000;            // observe output

    i_enable = 0;     // disable output
    #500;             // observe led off state

    $finish;          // end simulation
  end

endmodule
