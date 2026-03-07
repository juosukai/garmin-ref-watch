# Building & Installing Rugby Referee App

This guide details how to build the Rugby Referee App from source, sign it, and install it on your Garmin watch. This is useful if you want to modify the code, distribute a custom version, or install it on a device not yet supported by the official release.

## Prerequisites

1.  **Garmin Connect IQ SDK**: Download and install the [Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/).
2.  **Java Runtime Environment (JRE)**: Required for the SDK.
3.  **Visual Studio Code (VS Code)**: Recommended editor.
4.  **Monkey C Extension for VS Code**: Install from the VS Code Marketplace.

## 1. Generating a Developer Key

To build apps that can run on a physical device (even for personal use), you must sign them with a developer key.

1.  Open VS Code.
2.  Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3.  Type `Monkey C: Generate a Developer Key` and select it.
4.  Choose a location to save the `developer_key.der` file. **Keep this file safe!** You need it to update your app later.

## 2. Building the App

### Option A: Using Visual Studio Code (Recommended)

1.  Open the project folder in VS Code.
2.  Press `Ctrl+Shift+P`.
3.  Select `Monkey C: Build for Device`.
4.  Select your device model (e.g., `fenix6`, `fr245`, `venu2`).
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

## 3. Installing on Your Watch (Sideloading)

To install the app "as is" without going through the Connect IQ Store:

1.  Connect your Garmin watch to your computer via USB.
2.  It should appear as a mass storage drive (like a USB stick).
3.  Open the drive associated with your watch.
4.  Navigate to the `GARMIN` folder, then the `APPS` folder.
5.  Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6.  Safely disconnect/eject your watch from the computer.
7.  The app should now appear in your activity/app list on the watch.

## 4. Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the store):

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1.  **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2.  **Find the corresponding device ID** in the `manifest.xml` file. Look for the `<iq:product id="..."/>` tags (e.g., `fr245` for Forerunner 245, `fenix7` for Fenix 7).
3.  **Build the app specifically for that device ID** using the steps above. (Remember to use the `-r` release flag for optimal performance.)
4.  **Send them the `.prg` file**.
5.  Instruct them to follow the "Sideloading" steps above to install it.

## Troubleshooting

*   **App not showing up?**
    *   Ensure you built for the correct device model.
    *   Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
    *   Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/`.
*   **"iq!" icon appears?**
    *   This indicates a crash. Create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in `GARMIN/APPS/LOGS/` to see error logs.
