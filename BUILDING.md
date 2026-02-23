# Building & Installing Rugby Referee App

This guide details how to build the Rugby Referee App from source, install it on your Garmin watch, and package it for distribution.

## Prerequisites

Before you begin, ensure you have the following installed:

1.  **Visual Studio Code**: The recommended IDE for Monkey C development.
2.  **Monkey C Extension for VS Code**: Search for "Monkey C" in the VS Code Extensions marketplace and install it.
3.  **Connect IQ SDK**: Download and install the latest Connect IQ SDK from the [Garmin Developer site](https://developer.garmin.com/connect-iq/sdk/).
    -   Open VS Code.
    -   Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
    -   Type `Monkey C: Verify Installation` or `Monkey C: SDK Manager` to ensure the SDK is set up correctly.

## 1. generate a Developer Key

To build and sign the app (even for personal use), you need a developer key.

1.  Open the project in VS Code.
2.  Press `Ctrl+Shift+P` (or `Cmd+Shift+P`).
3.  Select **Monkey C: Generate a Developer Key**.
4.  Choose a location to save the `developer_key.der` file (e.g., in the project root or a secure location on your computer).
    *   **Note:** Keep this key safe! If you release an app to the store, you must use the same key for all future updates.

## 2. Building the App

### Option A: Sideloading (For Personal Use / Testing)

This method builds a `.prg` file that you can manually copy to your watch.

1.  Connect your Garmin watch to your computer via USB.
2.  In VS Code, press `Ctrl+Shift+P`.
3.  Select **Monkey C: Build for Device**.
4.  Select your device model (e.g., `fenix7`, `fr965`, etc.) from the list.
5.  Select an output folder (usually the `bin` folder in the project).
6.  A file named `rugby_referee.prg` (or similar) will be created in the `bin` folder.

### Option B: Exporting for Distribution (Connect IQ Store)

This method creates an `.iq` file which contains the app built for all supported devices. This is the file you upload to the Connect IQ Store.

1.  In VS Code, press `Ctrl+Shift+P`.
2.  Select **Monkey C: Export Project**.
3.  Choose the `bin` folder as the destination.
4.  This will generate a `.iq` file (e.g., `RugbyRefApp.iq`).

## 3. Installing on the Watch

### Sideloading (Manual Installation)

If you built a `.prg` file (Option A above):

1.  Ensure your watch is connected to your computer and appears as a drive (e.g., `GARMIN`).
2.  Open the `GARMIN` drive.
3.  Navigate to the `GARMIN/APPS/` folder.
4.  Copy the `.prg` file you built (from the `bin` folder) into the `GARMIN/APPS/` folder on your watch.
5.  Safely disconnect/eject your watch from the computer.
6.  The app should now appear in your activity/app list on the watch.

### Via Connect IQ Store

If you exported an `.iq` file (Option B above) and uploaded it to the store:

1.  Download the **Garmin Connect IQ Store** app on your phone.
2.  Search for "Rugby Referee App" (or the name you used).
3.  Tap **Install**.
4.  Sync your watch.

## Troubleshooting

-   **"Missing Developer Key"**: Ensure you have generated a key and configured the path in the Monkey C extension settings if prompted.
-   **"Device Not Found"**: Make sure your device is supported in the `manifest.xml`. If you have a newer device, you may need to update the SDK or add the device ID to the manifest.
