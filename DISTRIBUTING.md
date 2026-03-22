# Distributing the App "As Is"

This guide explains how to share the Rugby Referee App directly with others (e.g., friends or teammates) without publishing it to the Connect IQ Store. This process involves building device-specific files and sideloading them via USB.

## Building for Distribution

To distribute the app "as is", you must build a signed `.prg` file for the exact device your recipient owns.

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1.  **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2.  **Build the app specifically for that device ID**.
    *   **Using VS Code**: Press `Ctrl+Shift+P` (or `Cmd+Shift+P`), select `Monkey C: Build for Device`, and choose the recipient's exact device model.
    *   **Using Command Line**: Run the following command (replace `fenix5x` with the target device ID, and provide the path to your developer key):
        ```bash
        monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
        ```
    *   *Note: Always use the `-r` release flag when building from the command line for distribution to strip debug symbols and apply optimizations.*
3.  **Send the resulting `.prg` file** to the recipient.

## Installing on the Watch (Sideloading)

Instruct the recipient to follow these steps to install the app on their watch:

1.  Connect the Garmin watch to the computer via USB.
2.  It should appear as a mass storage drive (like a USB stick).
3.  Open the drive associated with the watch.
4.  Navigate to the `GARMIN` folder, then the `APPS` folder.
5.  Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6.  Safely disconnect/eject the watch from the computer.
7.  The app should now appear in the activity/app list on the watch.

## Troubleshooting

If the recipient has issues:
*   **App not showing up?**
    *   Ensure the `.prg` file was built for their exact device model.
    *   Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
    *   Ensure the file is placed directly in `GARMIN/APPS/`, not just `GARMIN/`.
*   **"iq!" icon appears?**
    *   This indicates a crash. Ask them to create a text file named `LOGS` or `TURNING_ON_LOGGING` (check Garmin docs for specific device instructions) in their `GARMIN/APPS/LOGS/` folder to see error logs.
