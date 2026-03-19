# Distributing Rugby Referee App "As Is"

This guide explains how to share the Rugby Referee App directly with other users (e.g., friends or teammates) without uploading it to the Garmin Connect IQ Store.

**Important Note:** Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for one watch model (like a `fenix5x`) and run it on a different model (like a `venu2`). A separate build is required for each target device model.

## 1. Determine the Target Device

Before building, you must ask the recipient for the exact model of their Garmin watch (e.g., Forerunner 245, Fenix 7, Venu 2).

## 2. Build for the Specific Device

You need to build a release version of the app specifically for their device ID.

### Using Visual Studio Code (Recommended)
1. Open the project in VS Code.
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3. Select `Monkey C: Build for Device`.
4. Choose the recipient's exact device model from the list.
5. Select a directory to save the output. This will generate a `.prg` file (e.g., `RugbyRefApp.prg`).

### Using Command Line (`monkeyc`)
If using the terminal, run the following command, replacing `[DEVICE_ID]` with the target device ID (e.g., `fenix6`, `fr245`) and adjusting paths as necessary:

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d [DEVICE_ID] -y /path/to/developer_key.der
```

*   `-r`: Creates a release build (strips debug symbols and applies optimizations). **Highly recommended for distribution.**
*   `-o`: Output file path for the built `.prg` file.
*   `-f`: The project jungle file (`monkey.jungle`).
*   `-d`: The target device ID. Refer to `manifest.xml` for supported Device IDs.
*   `-y`: Path to your generated developer key.

## 3. Share the File

Send the newly created `.prg` file to the recipient.

## 4. Instruct the Recipient to Sideload

Provide the recipient with these instructions to install the app on their watch:

1. Connect your Garmin watch to your computer using the USB cable.
2. The watch should mount as a mass storage drive (similar to a USB flash drive). Open the drive.
3. Navigate to the `GARMIN` folder, and then open the `APPS` folder inside it.
4. Copy the `.prg` file you received into the `GARMIN/APPS/` directory.
5. Safely disconnect/eject your watch from the computer.
6. The app should now be installed and appear in your activity or app list on the watch.
