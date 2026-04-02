# Distributing Rugby Referee App "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ Store), you can distribute it "As Is".

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## Steps for Distribution

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Find the Device ID**: Look up the corresponding Device ID in the `manifest.xml` file.
3. **Build the App**: Build the app specifically for that device ID using the instructions in [BUILDING.md](BUILDING.md).
   - **Crucial**: Remember to use the `-r` release flag for optimal performance when building via command line (e.g., `monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der`).
4. **Send the File**: Send the generated `.prg` file to the recipient.
5. **Installation Instructions**: Instruct them to follow the "Sideloading" steps below to install it.

## Sideloading Instructions for the Recipient

To install the provided `.prg` file on your watch:

1. Connect your Garmin watch to your computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with your watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the provided `.prg` file into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject your watch from the computer.
7. The app should now appear in your activity/app list on the watch.
