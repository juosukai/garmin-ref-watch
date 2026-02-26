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
    *   *Note: If you don't see your device, ensure it's listed in `manifest.xml`.*
5.  Select a directory to save the output.
6.  The build process will create a `.prg` file (e.g., `RugbyRefApp.prg`) in the chosen directory.

### Option B: Using Command Line (`monkeyc`)

If you prefer the terminal or want to create a release build:

1.  Ensure the Connect IQ SDK `bin` folder is in your system PATH.
2.  Run the following command (replace `fenix5x` with your target device ID):

```bash
monkeyc -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der -r
```

*   `-o`: Output file path.
*   `-f`: Project jungle file (usually `monkey.jungle`).
*   `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`). See `manifest.xml` for a full list of supported IDs.
*   `-y`: Path to your developer key.
*   `-r`: **Release build**. This optimizes the code and strips debug symbols, making the app smaller and faster. Recommended for distribution.

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

**Important**: Garmin apps are compiled for **specific device models**. You cannot take a file built for a `fenix5x` and run it on a `venu2`.

### Step-by-Step Guide for Distribution:

1.  **Identify the Recipient's Device**:
    *   Ask them for their exact watch model (e.g., Forerunner 245 Music, Fenix 7 Solar).
    *   Find the corresponding ID in `manifest.xml` (e.g., `fr245m`, `fenix7`).

2.  **Build Specifically for That Device**:
    *   Follow the "Building the App" steps above, selecting their device ID.
    *   Use the `-r` flag if building via command line for a release build.

3.  **Send the `.prg` File**:
    *   Locate the generated `.prg` file (e.g., `RugbyRefApp.prg`).
    *   Send *only* this file to your friend (via email, WhatsApp, etc.).
    *   They **do not** need the SDK, VS Code, or a developer key.

4.  **Instructions for the Recipient**:
    *   Tell them to connect their watch to a computer via USB.
    *   Copy the file to the `GARMIN/APPS/` folder on the watch drive.
    *   Unplug and play!

## Troubleshooting

*   **App not showing up?**
    *   **Wrong Device ID**: Ensure you built for the *exact* model (e.g., `fr245` vs `fr245m` matter!).
    *   **Filename Issues**: Keep the filename short and simple (e.g., `RugbyRef.prg`). Avoid special characters.
    *   **Wrong Folder**: Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/` or `GARMIN/APPS/LOGS`.
*   **"iq!" icon appears?**
    *   This indicates a crash.
    *   Create a empty text file named `LOGS` inside `GARMIN/APPS/LOGS/`.
    *   Reproduce the crash.
    *   Check `GARMIN/APPS/LOGS/CIQ_LOG.YML` for error details.
