# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ Store), you can distribute the compiled application file (`.prg`) manually.

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for one watch model (e.g., a `fenix5x`) and run it on another (e.g., a `venu2`). A separate build is required for each different target device model.

## 1. Finding the Recipient's Device ID

Ask the recipient for their exact watch model (e.g., Forerunner 245, Fenix 7). You can find the corresponding Connect IQ device ID in the `manifest.xml` file or the Garmin developer documentation.

## 2. Building for Distribution

You must build the app specifically for that device ID.

### Using Visual Studio Code

1. Open the project folder in VS Code.
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3. Select `Monkey C: Build for Device`.
4. Select the specific device model of the recipient.
5. Select a directory to save the output. This will create a `.prg` file.

### Using Command Line

When building via the command line, it is crucial to use the `-r` flag. This creates a release build that strips debug symbols and applies optimizations, ensuring optimal performance on the watch.

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <DEVICE_ID> -y /path/to/developer_key.der
```
*(Replace `<DEVICE_ID>` with the actual ID, e.g., `fenix6`)*

## 3. Sideloading (Installation)

Send the `.prg` file to the recipient and instruct them to perform the following steps to install it on their watch:

1. Connect the Garmin watch to a computer via USB.
2. The watch should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with the watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the provided `.prg` file into the `GARMIN/APPS/` directory.
6. Safely disconnect/eject the watch from the computer.
7. The app should now appear in the activity/app list on the watch.
