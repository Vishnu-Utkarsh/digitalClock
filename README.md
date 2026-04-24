# Digital Clock - Basys3

## Project Structure:

```text
DIGITALCLOCK.srcs/
├── sources_1/new/
│   ├── digitalClock.v      ← main code: handles User Interface
│   ├── display.v           ← 4-digit multiplexed 7-segment driver
│   ├── clock.v             ← Clock Module
│   ├── alarm.v             ← Alarm Module
│   ├── stopWatch.v         ← StopWatch module
│   ├── timer.v             ← Timer module
│   └── JohnsonCounter.v    ← Dynamic Light effect for alert
│   └── modX.v              ← Counter with a given MOD value
├── constrns_1/new/
│   └── kernel.xdc          ← Basys3 pin constraints
├── digitalClock.bit        ← BitStream File to be Programmed on Basys3 FPGA Board
└── README.md
```

## Features:
- Display current time in HH:MM:SS format on seven-segment displays
- Asynchronous reset to set time back to 00:00:00 for all modes
- Alarm functionality to set a specific time and trigger an alert when the current time matches the alarm time
- Stopwatch functionality to measure elapsed time
- Timer functionality to trigger an alert to measure time interval
- Optional Speed Control to adjust the clock's ticking speed for testing purposes
- Dot below 7-Segment Display to represent current mode (Time, ALarm, Stopwatch, Timer)
- Dynamic Light effect for alert at alarm and countdown trigger
- Toggle between time format (HH:MM, SS)
<!-- - Toggle between 24-hour and 12-hour time formats -->

## Controls:

### General

Switch (V16) - Asynchronous Reset: Set everything to default (00:00:00)

Up Button (T16) - Change Mode (Clock, Alarm, Stopwatch, Timer)

Down Button (U17) - change clock speed (or frequency) (1x, 10x, 100x, 1000x)

LED (L1) - Show current time format information

LED (P1) - Show Alarm status (ON/OFF)


### Clock

Center Button (U18) - Switch between time adjust modes (hour, minute, second)

Right Button (T17) - Adjust time (hour, minute, second)

switch (R2) - Toggle Time Format (HH:MM, SS)

switch (R1) - Alarm On/Off


### Alarm

Center Button (U18) - Switch between time setting modes (hour, minute)

Right Button (T17) - Adjust alarm time (hour, minute) other than 00:00
                   - Turn off Alarm


### Stopwatch

Center Button (U18) - Reset Stopwatch time (00:00:00)

Right Button (T17) - Pause Stopwatch time counter at instance

switch (R2) - Toggle Time Format (MM:SS, centiSeconds:centiSeconds)


### Timer

Center Button (U18) - Switch between timer adjust modes (hour, minute, second)

Right Button (T17) - Adjust timer countdown duration (hour, minute, second)
                   - Start/Pause Timer - Turn off Alert

switch (R2) - Toggle Time Format (HH:MM, SS)