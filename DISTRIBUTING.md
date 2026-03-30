# Distributing the App "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ store), you can distribute it "as is".

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Building the App for Distribution

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Determine the target device ID** for their watch (refer to `manifest.xml`).
3. **Build the app specifically for that device ID**. Using the command line, run the following command to create an optimized release build (replace `fenix5x` with the target device ID and the path to your developer key):

   ```bash
   monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
   ```

   * `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
   * `-o`: Output file path.
   * `-f`: Project jungle file (usually `monkey.jungle`).
   * `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`).
   * `-y`: Path to your developer key.

4. **Send them the built `.prg` file**.

## 2. Installing on the Watch (Sideloading)

Instruct the recipient to follow these steps to install the `.prg` file on their watch:

1. Connect your Garmin watch to your computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with your watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject your watch from the computer.
7. The app should now appear in your activity/app list on the watch.

## Troubleshooting

* **App not showing up?**
  * Ensure the app was built for the correct device model.
  * Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
  * Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/`.
* **"iq!" icon appears?**
  * This indicates a crash. Create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in `GARMIN/APPS/LOGS/` to see error logs.
