# Distributing "As Is" (Sideloading)

This guide explains how to share the Rugby Referee App directly with others or install it on your watch without using the Garmin Connect IQ Store.

## 1. Important: Device-Specific Builds

Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Identify the target device ID**: Refer to the `manifest.xml` file in this repository to find the correct device ID that corresponds to their watch model.

## 2. Creating a Release Build

To ensure optimal performance and remove debug symbols, you must create a release build using the `-r` flag.

Ensure you have the Connect IQ SDK installed and your developer key ready (see `BUILDING.md` for setup instructions).

Run the following command in your terminal, replacing `<device_id>` with the correct ID and the path to your key:

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
```

- `-r`: Creates a release build.
- `-o bin/RugbyRefApp.prg`: The output file path.
- `-f monkey.jungle`: The project file.
- `-d <device_id>`: The target device ID (e.g., `fenix6`, `fr945`, `venu`).
- `-y /path/to/developer_key.der`: Path to your developer key.

## 3. Installing on the Watch (Sideloading)

Once you have built the device-specific `.prg` file (or received one), follow these steps to install it:

1. Connect the Garmin watch to the computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with the watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject the watch from the computer.
7. The app should now appear in the activity/app list on the watch.
