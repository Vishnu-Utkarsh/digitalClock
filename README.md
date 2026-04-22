# Digital Clock
## Implemented Digital Clock (24 hr) on FPGA (basys 3) board using Vivado

### Features:
- Display current time in HH:MM:SS format on 6 seven-segment displays
- ALU to perform time calculations (incrementing seconds, minutes, hours)
- Asynchronous reset to set time back to 00:00:00
<!-- - Alarm functionality to set a specific time and trigger an alert when the current time matches the alarm time -->
<!-- - Toggle between 24-hour and 12-hour time formats -->
<!-- Timer and Stopwatch functionality to measure elapsed time and display it on the seven-segment displays -->
- Optional Speed Control to adjust the clock's ticking speed for testing purposes

### Controls:

Up Button (T16) - Change Mode (Clock, Alarm, Timer, Stopwatch)
Right Button (T17) - Increment time (seconds, minutes, hours)
Center Button (U18) - Switch between time setting modes (seconds, minutes, hours)
Down Button (U17) - change clock speed (or frequency) (1x, 10x, 100x, 1000x)

switch (V16) - Asynchronous reset (00:00:00)
switch (R2) - Toggle Time Format (hour minute / second)