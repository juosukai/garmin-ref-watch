# Distributing the App "As Is"

If you want to distribute this app directly to friends, teammates, or fellow referees without publishing it to the Connect IQ Store, you can do so by providing them with a compiled `.prg` file that they can sideload onto their watch.

This is known as distributing the app "As Is."

## Important: Device-Specific Builds

Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot build the app for a `fenix5x` and run that same `.prg` file on a `venu2`.

**A separate build is required for each different target device model.**

## 1. Identify the Target Device

Ask the recipient for their exact watch model (e.g., Forerunner 245, Fenix 7, Epix Gen 2). You will need this to identify the correct Connect IQ Device ID (e.g., `fr245`, `fenix7`, `epix2`). Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.

## 2. Build the App for the Specific Device

You must build a release version of the app specifically for their device ID.

**Using the Command Line (`monkeyc`):**

Ensure you have generated a developer key (`developer_key.der`). Run the following command, replacing `<device_id>` with the recipient's device ID and `/path/to/developer_key.der` with the path to your key:

```bash
monkeyc -r -o bin/RugbyRefApp-<device_id>.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
```

* `-r`: Creates a release build (strips debug symbols and applies optimizations). This is highly recommended for optimal performance and battery life.
* `-o`: Output file path. It is helpful to include the device ID in the filename.
* `-f`: Project jungle file (`monkey.jungle`).
* `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`).
* `-y`: Path to your developer key.

## 3. Distribute the `.prg` File

Once the build is complete, locate the generated `.prg` file (e.g., `bin/RugbyRefApp-fenix6.prg`). Send this file directly to the recipient via email, messaging app, or file sharing service.

## 4. Instructions for the Recipient (Sideloading)

Provide the following instructions to the person receiving the app so they can install it on their watch:

1. Connect your Garmin watch to your computer using its USB cable.
2. Your computer should recognize the watch as a mass storage drive or MTP device (similar to a USB flash drive).
3. Open the drive associated with your Garmin watch.
4. Navigate to the `GARMIN` folder, and then open the `APPS` folder inside it (`GARMIN/APPS/`).
5. Copy the `.prg` file you received and paste it directly into the `GARMIN/APPS/` folder.
6. Safely disconnect or eject your watch from the computer.
7. The app will now be installed and should appear in your watch's activity/app list.

### Troubleshooting for Recipients

* **App not showing up?**
  * Ensure the file was placed in `GARMIN/APPS/`, not just the root `GARMIN/` folder.
  * Ensure the `.prg` file corresponds to the correct watch model.
* **"iq!" icon appears?**
  * This indicates the app crashed upon starting. Verify that the app was compiled for the exact device model you are using.
