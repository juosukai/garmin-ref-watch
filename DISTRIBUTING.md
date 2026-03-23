# Distributing "As Is"

If you want to share the Rugby Referee App directly with friends or teammates (bypassing the Connect IQ Store), you will need to build the app and have them sideload it onto their watch.

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Ask for the Watch Model
Ask the recipient for their exact watch model (e.g., Forerunner 245, Fenix 7).

## 2. Build the App for that Device
You must build the app specifically for their device ID.

Ensure you have a generated developer key. (See `BUILDING.md` for instructions on how to generate one).

### Option A: Using Visual Studio Code
1. Open the project folder in VS Code.
2. Press `Ctrl+Shift+P`.
3. Select `Monkey C: Build for Device`.
4. Select their device model (e.g., `fenix6`, `fr245`, `venu2`).
5. Select a directory to save the output.
6. The build process will create a `.prg` file in the chosen directory.

### Option B: Using Command Line (`monkeyc`)
Run the following command, replacing `fenix5x` with their target device ID:
```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
```
*   `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
*   `-o`: Output file path.
*   `-f`: Project jungle file (usually `monkey.jungle`).
*   `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`). **Note:** Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.
*   `-y`: Path to your developer key.

## 3. Share the File
Send them the resulting `.prg` file.

## 4. Instruct them to Sideload
Instruct them to follow these steps to install the app on their watch:

1. Connect their Garmin watch to their computer via USB.
2. It should appear as a mass storage drive (like a USB stick).
3. Open the drive associated with their watch.
4. Navigate to the `GARMIN` folder, then the `APPS` folder.
5. Copy the built `.prg` file into the `GARMIN/APPS/` folder.
6. Safely disconnect/eject the watch from the computer.
7. The app should now appear in their activity/app list on the watch.
