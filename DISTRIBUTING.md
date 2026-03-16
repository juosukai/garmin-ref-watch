# Distributing Rugby Referee App "As Is"

This guide details how to build the Rugby Referee App from source, sign it, and install it on your Garmin watch, specifically if you want to distribute it directly to friends, teammates, or yourself without going through the Garmin Connect IQ Store.

## Prerequisites

1.  **Garmin Connect IQ SDK**: Download and install the [Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/).
2.  **Java Runtime Environment (JRE)**: Required for the SDK.
3.  **Visual Studio Code (VS Code)**: Recommended editor.
4.  **Monkey C Extension for VS Code**: Install from the VS Code Marketplace.

## 1. Generating a Developer Key

To build apps that can run on a physical device, you must sign them with a developer key.

1.  Open VS Code.
2.  Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3.  Type `Monkey C: Generate a Developer Key` and select it.
4.  Choose a location to save the `developer_key.der` file. Keep this file safe!

## 2. Building the App

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. A separate build is required for each different target device model. You cannot take a file built for a `fenix5x` and run it on a `venu2`.

Ask the recipient for their exact watch model (e.g., Forerunner 245, Fenix 7) before building.

### Option A: Using Visual Studio Code (Recommended)

1.  Open the project folder in VS Code.
2.  Press `Ctrl+Shift+P`.
3.  Select `Monkey C: Build for Device`.
4.  Select the **exact device model** the recipient owns.
5.  Select a directory to save the output.
6.  The build process will create a `.prg` file (e.g., `RugbyRefApp.prg`) in the chosen directory.

### Option B: Using Command Line (`monkeyc`)

If you prefer the terminal:

1.  Ensure the Connect IQ SDK `bin` folder is in your system PATH.
2.  Run the following command (replace `fenix5x` with your target device ID):

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
```

*   `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
*   `-o`: Output file path.
*   `-f`: Project jungle file (`monkey.jungle`).
*   `-d`: Target device ID. Refer to `manifest.xml` for the complete list of supported Device IDs.
*   `-y`: Path to your developer key.

## 3. Installing on the Watch (Sideloading)

Once you have the `.prg` file for the specific watch model, you can install it:

1.  Connect the Garmin watch to the computer via USB.
2.  It should appear as a mass storage drive (like a USB stick).
3.  Open the drive associated with the watch.
4.  Navigate to the `GARMIN` folder, then the `APPS` folder.
5.  Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6.  Safely disconnect/eject the watch from the computer.
7.  The app should now appear in the activity/app list on the watch.

If you are sending the app to someone else, simply send them the correctly built `.prg` file and the instructions in Step 3.
