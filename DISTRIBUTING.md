# Distributing "As Is" (Sideloading)

If you want to share the app with friends or teammates directly, bypassing the Connect IQ Store, you can distribute it "as is" using sideloading.

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Finding the Target Device ID

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. Check the `manifest.xml` file in this repository to find the corresponding Device ID for their watch model.

## 2. Building the App

Build the app specifically for their device ID.

### Option A: Using Visual Studio Code (Recommended)
1. Open the project folder in VS Code.
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3. Select `Monkey C: Build for Device`.
4. Select the recipient's exact device model.
5. Select a directory to save the output `.prg` file.

### Option B: Using Command Line (`monkeyc`)
Run the following command, replacing `<device_id>` with the target device ID from `manifest.xml`, and `/path/to/developer_key.der` with the path to your developer key (see `BUILDING.md` for how to generate one).

```bash
monkeyc -r -o bin/RugbyRefApp-<device_id>.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
```
*Note: The `-r` flag creates a release build (strips debug symbols and applies optimizations). This is highly recommended for distribution.*

## 3. Distributing the File

Send the generated `.prg` file to the recipient.

## 4. Installing on the Watch (Sideloading)

Instruct the recipient to follow these steps to install the app on their watch:

1. Connect the Garmin watch to a computer via USB.
2. The watch should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with the watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the `.prg` file into the `GARMIN/APPS/` folder. Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
6. Safely disconnect/eject the watch from the computer.
7. The app should now appear in the activity/app list on the watch.

## Troubleshooting

*   **App not showing up?**
    *   Ensure you built for the correct device model.
    *   Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
    *   Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/`.
*   **"iq!" icon appears?**
    *   This indicates a crash. Create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in `GARMIN/APPS/LOGS/` to see error logs.
