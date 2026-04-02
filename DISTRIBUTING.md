# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the store):

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Build the app specifically for that device ID** using the steps below. (Remember to use the `-r` release flag for optimal performance.)
3. **Send them the `.prg` file**.
4. Instruct them to follow the "Sideloading" steps below to install it.

## Building the App for a Specific Device

1. Ensure the Connect IQ SDK `bin` folder is in your system PATH.
2. Run the following command (replace `fenix5x` with your target device ID):

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
```

* `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
* `-o`: Output file path.
* `-f`: Project jungle file (usually `monkey.jungle`).
* `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`). **Note:** Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.
* `-y`: Path to your developer key.

## Installing on Your Watch (Sideloading)

To install the app "as is" without going through the Connect IQ Store:

1. Connect your Garmin watch to your computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with your watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject your watch from the computer.
7. The app should now appear in your activity/app list on the watch.
