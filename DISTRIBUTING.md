# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ Store), you can distribute the application "as is" by building device-specific `.prg` files and sideloading them manually via USB.

**Important:** Signed `.prg` files generated for sideloading are strictly device-specific and cannot be shared across different Garmin watch models; a separate build is required for each target device. You cannot take a file built for a `fenix5x` and run it on a `venu2`.

## 1. Ask the recipient for their exact watch model

Identify the specific Garmin watch model your recipient is using (e.g., Forerunner 245, Fenix 7). Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.

## 2. Build the app specifically for that device ID

You will need to generate a `.prg` file for their specific device.

If using the command line (`monkeyc`), you must build and sign the application using a generated developer key. To create a release build for distribution via the command line, the `-r` flag must be used with `monkeyc` to ensure optimization and debug symbol stripping.

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
```

Replace `<device_id>` with the exact device ID corresponding to their watch model.

For instructions on generating a developer key or building using Visual Studio Code, refer to [BUILDING.md](BUILDING.md).

## 3. Send them the `.prg` file

Once the build is successful, a `.prg` file (e.g., `RugbyRefApp.prg`) will be generated. Send this specific file to your recipient.

## 4. Installing on Your Watch (Sideloading)

Instruct the recipient to follow these steps to install the `.prg` file via USB:

1. Connect your Garmin watch to your computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with your watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the `.prg` file you received into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject your watch from the computer.
7. The app should now appear in your activity/app list on the watch.

## Troubleshooting

If the app does not show up on the watch:

- Ensure the app was built for the correct device model.
- Ensure the `.prg` filename is short and contains only letters/numbers (e.g., `RugbyRef.prg`).
- Ensure the file is placed directly in the `GARMIN/APPS/` folder, not just `GARMIN/`.

If an "iq!" icon appears, this indicates a crash. Refer to Garmin's documentation for instructions on enabling crash logging for specific device models.
