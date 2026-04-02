# Distributing Rugby Referee App "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ Store), you can distribute it "as is".

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Build for the specific device

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Build the app specifically for that device ID**. You can use Visual Studio Code or the command line.

### Using Command Line (`monkeyc`)

Ensure the Connect IQ SDK `bin` folder is in your system PATH. Run the following command (replace `<device_id>` with the target device ID and `/path/to/developer_key.der` with your developer key path):

```bash
monkeyc -r -o bin/RugbyRefApp_<device_id>.prg -f monkey.jungle -d <device_id> -y /path/to/developer_key.der
```

* `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
* `-o`: Output file path. Naming it with the device ID helps keep track of which file is for which device.
* `-f`: Project jungle file (usually `monkey.jungle`).
* `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`). **Note:** Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.
* `-y`: Path to your developer key.

## 2. Send the file

**Send them the built `.prg` file** (e.g., `RugbyRefApp_fenix5x.prg`).

## 3. Instruct them to sideload

Instruct the recipient to follow these "Sideloading" steps to install it on their watch:

1. Connect the Garmin watch to a computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with the watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the `.prg` file into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject the watch from the computer.
7. The app should now appear in the activity/app list on the watch.
