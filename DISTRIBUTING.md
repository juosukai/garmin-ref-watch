# Distributing Rugby Referee App "As Is"

If you want to share the app with friends or teammates directly (bypassing the Connect IQ Store), you can distribute it "As Is" by providing them with a compiled `.prg` file.

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

## 1. Building the App for Distribution

You will need to build the app specifically for the recipient's exact watch model.

### Prerequisites
Make sure you have generated a developer key and set up your build environment as described in [BUILDING.md](BUILDING.md).

### Building via Visual Studio Code
1.  Ask the recipient for their exact watch model (e.g., Forerunner 245, Fenix 7).
2.  Open the project folder in VS Code.
3.  Press `Ctrl+Shift+P`.
4.  Select `Monkey C: Build for Device`.
5.  Select the corresponding device model.
6.  Select a directory to save the output. This generates the `.prg` file.

### Building via Command Line (`monkeyc`)
You can use the `monkeyc` tool to build a release version. A release build is highly recommended for distribution as it strips debug symbols and applies optimizations.
Run the following command (replace `fenix5x` with the target device ID):

```bash
monkeyc -r -o bin/RugbyRefApp.prg -f monkey.jungle -d fenix5x -y /path/to/developer_key.der
```
*(Remember to use the `-r` release flag for optimal performance.)*

## 2. Installing on the Watch (Sideloading)

Once you have built the device-specific `.prg` file, send it to the recipient and instruct them to follow these steps to install it:

1.  Connect your Garmin watch to your computer via USB.
2.  It should appear as a mass storage drive (like a USB stick).
3.  Open the drive associated with your watch.
4.  Navigate to the `GARMIN` folder, then the `APPS` folder.
5.  Copy the built `.prg` file (e.g., `RugbyRefApp.prg`) into the `GARMIN/APPS/` folder.
6.  Safely disconnect/eject your watch from the computer.
7.  The app should now appear in your activity/app list on the watch.
