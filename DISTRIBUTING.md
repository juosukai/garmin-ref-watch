# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the store), you can distribute it "as is".

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Ask the recipient for their exact watch model
You need to know the specific model (e.g., Forerunner 245, Fenix 7) to build the correct `.prg` file.

## 2. Build the app specifically for that device ID
You can use either VS Code or the command line to build the app.

### Using Visual Studio Code (Recommended)
1. Open the project folder in VS Code.
2. Press `Ctrl+Shift+P`.
3. Select `Monkey C: Build for Device`.
4. Select the target device model (e.g., `fenix6`, `fr245`, `venu2`).
5. Select a directory to save the output.
6. The build process will create a `.prg` file (e.g., `RugbyRefApp.prg`) in the chosen directory.

### Using Command Line (`monkeyc`)
Run the following command (replace `fenix5x` with your target device ID):

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
```

*   `-r`: Creates a release build (strips debug symbols and applies optimizations). Highly recommended for distribution.
*   `-o`: Output file path.
*   `-f`: Project jungle file (usually `monkey.jungle`).
*   `-d`: Target device ID (e.g., `fenix6`, `fr945`, `venu`). **Note:** Refer to the `manifest.xml` file for the complete list of supported Device IDs for this project.
*   `-y`: Path to your developer key.

## 3. Send them the `.prg` file
Send the built `.prg` file to the recipient.

## 4. Instruct them to follow the "Sideloading" steps to install it
To install the app on their watch:
1.  Connect the Garmin watch to the computer via USB.
2.  It should appear as a mass storage drive (like a USB stick).
3.  Open the drive associated with the watch.
4.  Navigate to the `GARMIN` folder, then the `APPS` folder.
5.  Copy the `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6.  Safely disconnect/eject the watch from the computer.
7.  The app should now appear in the activity/app list on the watch.
