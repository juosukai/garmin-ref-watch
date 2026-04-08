# Distributing the App

## 1. Installing on Your Watch (Sideloading)

To install the app "as is" without going through the Connect IQ Store:

1. Connect your Garmin watch to your computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with your watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject your watch from the computer.
7. The app should now appear in your activity/app list on the watch.

## 2. Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the store):

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Build the app specifically for that device ID** using the steps above. (Remember to use the `-r` release flag for optimal performance.)
3. **Send them the `.prg` file**.
4. Instruct them to follow the "Sideloading" steps above to install it.

## Troubleshooting

* **App not showing up?**
  * Ensure you built for the correct device model.
  * Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
  * Ensure the file is in `GARMIN/APPS/`, not just `GARMIN/`.
* **"iq!" icon appears?**
  * This indicates a crash. Create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in `GARMIN/APPS/LOGS/` to see error logs.
