# Distributing "As Is"

If you want to share the Rugby Referee App with friends or teammates directly (bypassing the Garmin Connect IQ Store), you can distribute it "as is".

## Important Requirement: Device-Specific Builds

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for one watch model (e.g., `fenix5x`) and run it on a different model (e.g., `venu2`). A separate build is required for each different target device model.

## Steps for Distribution

1.  **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2.  **Determine the Device ID** from the `manifest.xml` file. The file acts as the reference for available Device IDs when building for specific targets.
3.  **Build the app specifically for that device ID**.
    *   It is highly recommended to use the `-r` release flag for optimal performance.
    *   Command line example:
        ```bash
        monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
        ```
    *   (See [BUILDING.md](BUILDING.md) for full build instructions and setting up your developer key.)
4.  **Send them the built `.prg` file**.
5.  **Instruct them to sideload the app:**
    1. Connect their Garmin watch to their computer via USB.
    2. It should appear as a mass storage drive (like a USB stick).
    3. Open the drive associated with the watch.
    4. Navigate to the `GARMIN` folder, then the `APPS` folder.
    5. Copy the built `.prg` file into the `GARMIN/APPS/` folder.
    6. Safely disconnect/eject the watch from the computer.
    7. The app should now appear in their activity/app list on the watch.

## Troubleshooting
* If the app doesn't show up:
  * Check if it was built for the exact watch model.
  * The file must be inside `GARMIN/APPS/`, not the root `GARMIN/` folder.
* "iq!" icon on the watch:
  * This means the app crashed. Have them create a folder or text file named `LOGS` in `GARMIN/APPS/LOGS/` to record the error.
