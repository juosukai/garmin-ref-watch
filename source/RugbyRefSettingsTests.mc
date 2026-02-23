using Toybox.Test as Test;
using Toybox.Application.Storage as Storage;
using Toybox.Graphics as Gfx;

(:test)
function testLoadSettingsInvalidDuration(logger) {
    // 1. Setup invalid settings
    // Save string where number expected
    Storage.setValue("halfDuration", "invalid_string");
    // Save negative number where positive expected
    Storage.setValue("sinBinDuration", -10);
    // Save 0 where positive expected (assuming duration must be positive)
    Storage.setValue("breakDuration", 0);

    // 2. Initialize view (which calls loadSettings)
    var view = new RugbyRefView();

    // 3. Verify defaults are loaded
    // If the vulnerability exists, these checks would fail (or the view might have crashed)
    // We expect the fix to ensure defaults are used.

    var halfDur = view.getHalfDuration();
    if (halfDur != RugbyConstants.DEFAULT_HALF_DURATION) {
        logger.debug("Expected default half duration (" + RugbyConstants.DEFAULT_HALF_DURATION + "), got: " + halfDur);
        return false;
    }

    var sinBinDur = view.getSinBinDuration();
    if (sinBinDur != RugbyConstants.DEFAULT_SIN_BIN_DURATION) {
        logger.debug("Expected default sin bin duration (" + RugbyConstants.DEFAULT_SIN_BIN_DURATION + "), got: " + sinBinDur);
        return false;
    }

    // Depending on implementation, 0 might be allowed or not.
    // Ideally it should be sanitized to default if invalid.
    // Let's assume we want strictly positive durations.
    var breakDur = view.getBreakDuration();
    if (breakDur != RugbyConstants.DEFAULT_BREAK_DURATION) {
        logger.debug("Expected default break duration (" + RugbyConstants.DEFAULT_BREAK_DURATION + "), got: " + breakDur);
        return false;
    }

    // Cleanup
    Storage.deleteValue("halfDuration");
    Storage.deleteValue("sinBinDuration");
    Storage.deleteValue("breakDuration");

    return true;
}

(:test)
function testLoadSettingsInvalidTypes(logger) {
    // 1. Setup invalid types
    Storage.setValue("vibrateEnabled", "not_a_boolean");
    Storage.setValue("homeColor", "blue"); // String instead of Number
    Storage.setValue("reminderEnabled", 123); // Number instead of Boolean

    // 2. Initialize view
    var view = new RugbyRefView();

    // 3. Verify defaults
    if (view.isVibrateEnabled() != true) { // Default is true
        logger.debug("Expected vibrate enabled default (true), got: " + view.isVibrateEnabled());
        return false;
    }

    var homeColor = view.getHomeColor();
    // Default is Gfx.COLOR_BLUE.
    // If vulnerability exists, homeColor would be "blue".
    if (homeColor instanceof String) {
         logger.debug("Home color should not be a string");
         return false;
    }

    if (view.isReminderEnabled() != true) { // Default is true
        logger.debug("Expected reminder enabled default (true), got: " + view.isReminderEnabled());
        return false;
    }

    // Cleanup
    Storage.deleteValue("vibrateEnabled");
    Storage.deleteValue("homeColor");
    Storage.deleteValue("reminderEnabled");

    return true;
}
