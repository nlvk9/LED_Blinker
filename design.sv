/* The idea:
- Blink an LED at a given frequency (based on the value of 2 switches an an enable input)
- Define the constant frequencies --> specifically how many clock cycles occur between the LED being on 
and the LED being off
- Create 4 counts for each of the 4 frequencies
- Create 4 toggles for each of the 4 frequencies
- Increment the counts by 1 each rising edge.
- Check if the toggles have been turned on for each respective count
- Check the switches and the enable pin to see which frequency/toggle is being focused on
- The "on" variable (should be defined as a parameter) is equal to the toggle and-ed with the enable pin
25kHz oscillator
*/

`timescale 1us/1ns

module led_blink (input  i_clock,
                  input  i_switch_1,
                  input  i_switch_2,
                  input  i_enable,
                  output o_led_state);
  // frequencies
  // 125 cycles between ON states
  parameter frequency_100HZ = 125;
  parameter frequency_50HZ  = 250;
  parameter frequency_10HZ  = 1250;
  parameter frequency_1HZ   = 12500;
  
  // set the counts to 0
  reg[6:0]  count_1 = 1'b0;
  reg[7:0]  count_2 = 1'b0;
  reg[10:0] count_3 = 1'b0;
  reg[13:0] count_4 = 1'b0;
  
  // toggles
  reg toggle_1 = 1'b0;
  reg toggle_2 = 1'b0;
  reg toggle_3 = 1'b0;
  reg toggle_4 = 1'b0;
  
  reg selected_signal = 1'b0;
  
  // increment the counts using a rising clock edge
  always @ (posedge i_clock) begin 
      count_1 <= count_1 + 1;
      if (count_1 == frequency_100HZ - 1) begin
        toggle_1 <= !toggle_1;
        count_1 <= 0;
      end
      
      count_2 <= count_2 + 1;
      if (count_2 == frequency_50HZ - 1) begin
        toggle_2 <= !toggle_2;
        count_2 <= 0;
      end
      
      count_3 <= count_3 + 1;
      if (count_3 == frequency_10HZ - 1) begin
        toggle_3 <= !toggle_3;
        count_3 <= 0;
      end
      
      count_4 <= count_4 + 1;
      if (count_4 == frequency_1HZ - 1) begin
        toggle_4 <= !toggle_4;
        count_4 <= 0;
      end
   end
  
  // if any signal changes
  always @(*) begin
    if (i_switch_1 == 1 && i_switch_2 == 1) begin
      selected_signal = toggle_1;
    end else if (i_switch_1 == 1 && i_switch_2 == 0) begin
      selected_signal = toggle_2;
    end else if (i_switch_1 == 0 && i_switch_2 == 1) begin
      selected_signal = toggle_3;
    end else if (i_switch_1 == 0 && i_switch_2 == 0) begin
      selected_signal = toggle_4;
    end 
  end
  
  assign o_led_state = selected_signal & i_enable;
  
endmodule
