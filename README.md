# Rugby Referee App for Garmin Fenix 5X

A free, open-source rugby referee assistant app for Garmin watches.

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

For detailed instructions on building, signing, sideloading, and distributing the app, please see [BUILDING.md](BUILDING.md).

### Prerequisites

1. Install the [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
2. Install Visual Studio Code with the "Monkey C" extension (or use Eclipse)

### Build Instructions

1. Open this project folder in VS Code
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
3. Select "Monkey C: Build for Device"
4. Choose "fenix5x" as your target device

### Install on Watch

**Option 1: Using Simulator**
1. Press `Ctrl+Shift+P` and select "Monkey C: Run in Simulator"
2. Select "fenix5x" simulator

**Option 2: On Real Device**
1. Connect your Fenix 5X via USB
2. Press `Ctrl+Shift+P` and select "Monkey C: Run on Device"
3. The app will be installed on your watch

**Option 3: Manual Installation**
1. Build the app (creates a `.prg` file in the `bin` folder)
2. Connect watch via USB
3. Copy the `.prg` file to `GARMIN/APPS/` folder on your watch
4. Disconnect and find the app in your watch's app menu

**Option 4: Distributing As Is**
1. Ask the recipient for their exact watch model.
2. Find the corresponding device ID in `manifest.xml` and build the app specifically for that device ID.
3. Send them the compiled `.prg` file and instruct them to manually install it following Option 3.
4. See the "Distributing 'As Is'" section in [BUILDING.md](BUILDING.md#4-distributing-as-is) for detailed instructions.

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
