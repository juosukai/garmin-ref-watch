# Distributing "As Is"

If you want to share the app with friends or teammates directly (bypassing the store):

**Important**: Signed `.prg` files generated for sideloading are **strictly device-specific**. You cannot take a file built for a `fenix5x` and run it on a `venu2`. A separate build is required for each different target device model.

1. **Ask the recipient for their exact watch model** (e.g., Forerunner 245, Fenix 7).
2. **Build the app specifically for that device ID** using the steps in [BUILDING.md](BUILDING.md). (Remember to use the `-r` release flag for optimal performance.)
3. **Send them the `.prg` file**.
4. Instruct them to follow the "Sideloading" steps in [BUILDING.md](BUILDING.md) to install it.
