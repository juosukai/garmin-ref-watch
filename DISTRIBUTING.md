# Distributing Rugby Referee App "As Is"

This guide details how to distribute the Rugby Referee App directly to users
without going through the Garmin Connect IQ Store. This method is often called
"sideloading".

## Important: Device Specificity

**Signed `.prg` files generated for sideloading are strictly device-specific.**

You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate
build is required for each different target device model.

If you are distributing the app to a friend or teammate, you must:

1. **Ask them for their exact Garmin watch model.**
2. **Determine the corresponding Connect IQ Device ID** (refer to the
    `manifest.xml` file for supported IDs).
3. **Build a specific `.prg` file for that exact device.**

## 1. Building for Distribution

To distribute the app, you should create a **release build**. Release builds are
optimized and have debug symbols stripped, resulting in better performance and
smaller file size.

### Prerequisites

* You must have the Garmin Connect IQ SDK installed.
* You must have generated a developer key (`.der` file). Even for "As Is"
    distribution, the app must be signed. See `BUILDING.md` for instructions on
    generating a key.

### Command Line Build

The standard CLI command to compile a release build for a specific device is:

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d <device_id> \
  -y /path/to/developer_key.der
```

* `-r`: Creates a release build (strips debug symbols and applies
    optimizations).
* `-o bin/RugbyRefApp.prg`: The output path and filename for the built app.
* `-f monkey.jungle`: The project configuration file.
* `-d <device_id>`: The target device ID (e.g., `fenix6`, `fr245`).
* `-y /path/to/developer_key.der`: The path to your generated developer key.

*Example for a Fenix 6:*

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix6 \
  -y ~/my_keys/developer_key.der
```

This will generate a file named `RugbyRefApp.prg` in the `bin/` directory.

## 2. Installing on the Watch (Sideloading)

Once you have built the correct `.prg` file for the target device, the user can
install it manually via USB.

### Instructions for the User

1. **Connect the Garmin watch** to your computer using its USB charging cable.
2. The watch should appear as a mass storage drive on your computer (like a USB
    flash drive).
3. Open the drive associated with your watch.
4. Navigate into the `GARMIN` folder.
5. Inside the `GARMIN` folder, find and open the `APPS` folder.
6. **Copy the `.prg` file** (e.g., `RugbyRefApp.prg`) that was provided to you
    into the `GARMIN/APPS/` folder.
7. **Safely eject or disconnect** the watch from your computer.
8. The watch will process the new file, and the "Rugby Referee App" should now
    appear in your list of activities and apps.

## Troubleshooting Sideloading

* **App does not appear in the menu:** Double-check that the file was placed
    exactly in the `GARMIN/APPS/` directory, and not just the root `GARMIN/`
    folder.
* **"iq!" Icon appears on the watch:** This indicates the app crashed on
    startup. The most common cause for sideloaded apps is that the `.prg` file
    was built for the **wrong device model**. You must build a new file
    specifically for that user's watch model.
