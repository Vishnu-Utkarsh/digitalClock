# Digital Clock - Basys3

## Project Structure:
DIGITALCLOCK.srcs/
├── sources_1/new/
│   ├── digitalClock.v      ← main code: handles User Interface
│   ├── display.v           ← 4-digit multiplexed 7-segment driver
│   ├── clock.v             ← Clock Module
│   ├── alarm.v             ← Alarm Module
│   ├── stopWatch.v         ← StopWatch module
│   └── JohnsonCounter.v    ← Dynamic Light as an alternative of alarm sound
│   └── modX.v              ← Counter with a given MOD value
├── constrns_1/new/
│   └── kernel.xdc          ← Basys3 pin constraints
├── digitalClock.bit        ← BitStream File to be Programmed on Basys3 FPGA Board
└── README.md

## Features:
- Display current time in HH:MM:SS format on seven-segment displays
- ALU to perform time calculations (incrementing seconds, minutes, hours)
- Asynchronous reset to set time back to 00:00:00
- Alarm functionality to set a specific time and trigger an alert when the current time matches the alarm time
- Timer and Stopwatch functionality to measure elapsed time
- Optional Speed Control to adjust the clock's ticking speed for testing purposes
<!-- - Toggle between 24-hour and 12-hour time formats -->

## Controls:

Up Button (T16) - Change Mode (Clock, Alarm, Stopwatch, Timer)
Right Button (T17) - Increment time (seconds, minutes, hours)
Center Button (U18) - Switch between time setting modes (seconds, minutes, hours)
Down Button (U17) - change clock speed (or frequency) (1x, 10x, 100x, 1000x)

switch (V16) - Asynchronous reset (00:00:00)
switch (R2) - Toggle Time Format (hour minute / second)
