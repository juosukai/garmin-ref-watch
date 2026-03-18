# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the store), or install it on your watch via sideloading, follow these instructions.

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Determine the Target Device

1.  **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2.  **Find the device ID** in the `manifest.xml` file. The `id` attribute in the `<iq:product>` tags corresponds to the specific device model.

## 2. Building the App

To distribute the app, you need to build it specifically for the target device ID.

### Option A: Using Visual Studio Code (Recommended)

1.  Open the project folder in VS Code.
2.  Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3.  Select `Monkey C: Build for Device`.
4.  Select the target device model (e.g., `fenix6`, `fr245`, `venu2`).
5.  Select a directory to save the output.
6.  The build process will create a `.prg` file (e.g., `RugbyRefApp.prg`) in the chosen directory.

### Option B: Using Command Line (`monkeyc`)

If you prefer the terminal or want to script the build:

1.  Ensure the Connect IQ SDK `bin` folder is in your system PATH.
2.  Run the following command (replace `fenix5x` with your target device ID):

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
```

*   `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
*   `-o`: Output file path.
*   `-f`: Project jungle file (usually `monkey.jungle`).
*   `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`). **Note:** Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.
*   `-y`: Path to your developer key.

## 3. Installing on the Watch (Sideloading)

To install the app "as is" without going through the Connect IQ Store:

1.  Connect the Garmin watch to the computer via USB.
2.  It should appear as a mass storage drive (like a USB stick).
3.  Open the drive associated with the watch.
4.  Navigate to the `GARMIN` folder, then the `APPS` folder.
5.  Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6.  Safely disconnect/eject the watch from the computer.
7.  The app should now appear in the activity/app list on the watch.

## Troubleshooting

*   **App not showing up?**
    *   Ensure you built for the correct device model.
    *   Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
    *   Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/`.
*   **"iq!" icon appears?**
    *   This indicates a crash. Create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in `GARMIN/APPS/LOGS/` to see error logs.
