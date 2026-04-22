# digitalClock
## Implemented Digital Clock (24 hr) on FPGA (basys 3) board using Vivado

### Features:
- Display current time in HH:MM:SS format on 6 seven-segment displays
- ALU to perform time calculations (incrementing seconds, minutes, hours)
- Asynchronous reset to set time back to 00:00:00
<!-- - Alarm functionality to set a specific time and trigger an alert when the current time matches the alarm time -->
<!-- - Toggle between 24-hour and 12-hour time formats -->
<!-- Timer and Stopwatch functionality to measure elapsed time and display it on the seven-segment displays -->

### Controls:

Down Button (U17) - change clock speed

switch (V16) - Asynchronous reset (00:00:00)

switch (R2) - Toggle Time Format (hour minute / second)