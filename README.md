# Rugby Referee App for Garmin Watches

A free, open-source rugby referee assistant app for Garmin watches (Fenix 5/6/7/8, Forerunner, Venu, Epix, etc.).

## Features

- **Configurable Match Timer**: Set duration for any rugby format
  - Quick presets: Rugby 7s, 10s, Youth/12-a-side, Full 15s
  - Custom durations: 7, 10, 15, 20, 25, 30, 35, or 40 minutes per half
  - Automatic overtime tracking (shows +MM:SS after target time)
  - **60-Second Reminder**: Gentle vibration when clock stopped for 60+ seconds
  
- **Score Tracking with Undo**: Track scores for both Home and Away teams
  - Try (5 points)
  - Conversion (2 points)
  - Penalty (3 points)
  - Drop Goal (3 points)
  - **Undo last score** if you make a mistake
  
- **Team Color Customization**: Choose colors for each team
  - 10 colors: Red, Blue, Green, Yellow, Orange, Purple, Pink, White, Lt Gray, Dk Gray
  - Perfect for matching team jerseys or improving visibility
  
- **Kick Shot Clock**: Time-limited kicks with countdown
  - **Conversion**: 60 seconds
  - **Penalty Kick**: 90 seconds
  - Visual warning at 10 seconds remaining
  - Vibration alert when time expires
  
- **Configurable Sin Bin Timer**: 2 min (7s), 5 min (youth), or 10 min (15s)
  
- **Half-time Management**: 
  - Automatic half-time break screen
  - Configurable break duration (1, 5, 10, or 15 minutes)
  - Press SELECT to start second half
  
- **Match Summary Screen**: After finishing a match
  - Final score display with team colors
  - Half-time statistics
  - Total match time
  
- **Smart Vibration Alerts**: 
  - Half-time and full-time
  - Sin bin completion
  - 60s stopped reminder
  - Kick timer warnings
  - All can be disabled in settings
  
- **Persistent Settings**: All preferences saved between sessions

## Controls

- **SELECT (center button)**: Start/Stop match timer (or start second half during break)
- **UP button**: Quick score menu for Away team
- **DOWN button**: Quick score menu for Home team
- **MENU button**: Access main menu
  - **Undo Last Score** - Fix scoring mistakes
  - **Conversion (60s)** - Start conversion timer
  - **Penalty Kick (90s)** - Start penalty kick timer
  - **Stop Kick Timer** - Cancel active kick timer
  - **Start Sin Bin** - Start 10-minute yellow card timer
  - **Stop Sin Bin** - Cancel sin bin timer
  - **Half Time** - Start half-time break
  - **Finish Match** - View match summary
  - **Reset Match** - Full reset to new match
  - **Settings**
    - Match Format (quick presets)
    - Half Duration
    - Sin Bin Duration
    - Break Duration
    - Team Colors (Home & Away)
    - Vibration toggle
    - 60s Reminder toggle
- **BACK button**: Exit app

## Building & Installation

For detailed instructions on how to build the app, generate a developer key, and install it on your watch (including sideloading), please see [BUILDING.md](BUILDING.md).

### Quick Start

1.  **Install Prerequisites**: VS Code, Monkey C Extension, Connect IQ SDK.
2.  **Generate Developer Key**: In VS Code, run `Monkey C: Generate a Developer Key`.
3.  **Build**: Run `Monkey C: Build for Device` and select your device model.
4.  **Install**: Copy the generated `.prg` file (from `bin/`) to the `GARMIN/APPS/` folder on your watch.

For more details on exporting for the store or troubleshooting, refer to the [full build guide](BUILDING.md).

## Settings & Customization

All settings can be configured through the watch interface (MENU → Settings):

### Quick Format Presets:
- **Rugby 7s**: 7 min halves, 2 min sin bin, 1 min break
- **Rugby 10s**: 20 min halves, 10 min sin bin, 5 min break
- **Youth/12-a-side**: 25 min halves, 5 min sin bin, 10 min break
- **12-a-side**: 30 min halves, 10 min sin bin, 10 min break
- **Full 15s**: 40 min halves, 10 min sin bin, 10 min break
- **Custom**: Set each value individually

All settings persist between uses, so you only need to configure once for your typical matches.

## License

MIT License - Free to use and modify

## Contributing

Feel free to fork and improve! Pull requests welcome.
