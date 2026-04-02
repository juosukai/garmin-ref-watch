# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ store), you need to build a device-specific release and sideload it.

## 1. Generating a Developer Key

To build apps that can run on a physical device, you must sign them with a developer key.

1. Open VS Code.
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac).
3. Type `Monkey C: Generate a Developer Key` and select it.
4. Choose a location to save the `developer_key.der` file. **Keep this file safe!**

## 2. Building the App for a Specific Device

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Find the device ID** for that model (e.g., `fr245`, `fenix7`) in `manifest.xml`.
3. **Build a release version** via the command line:

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
```

* `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
* `-o`: Output file path.
* `-d`: Target device ID.
* `-y`: Path to your developer key.

## 3. Installing on the Watch (Sideloading)

Instruct the recipient to follow these steps:

1. Connect the Garmin watch to the computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with the watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject the watch from the computer.
7. The app should now appear in the activity/app list on the watch.

## Troubleshooting

* **App not showing up?**
  * Ensure you built for the correct device model.
  * Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
  * Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/`.
* **"iq!" icon appears?**
  * This indicates a crash. Create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in `GARMIN/APPS/LOGS/` to see error logs.
