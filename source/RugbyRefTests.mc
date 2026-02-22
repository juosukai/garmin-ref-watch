using Toybox.Test as Test;

(:test)
function testAddScoreHome(logger) {
    var view = new RugbyRefView();

    // Initial state
    if (view.getScoreHome() != 0) {
        logger.debug("Initial home score should be 0");
        return false;
    }

    // Test adding 5 points (Try)
    view.setMatchTime(100);
    view.setHalf(1);
    view.addScoreHome(5);

    if (view.getScoreHome() != 5) {
        logger.debug("Home score should be 5 after try");
        return false;
    }

    var history = view.getScoreHistory();
    if (history.size() != 1) {
        logger.debug("History size should be 1");
        return false;
    }

    var entry = history[0];
    if (entry["team"] != :home) {
        logger.debug("History entry team should be :home");
        return false;
    }
    if (entry["points"] != 5) {
        logger.debug("History entry points should be 5");
        return false;
    }
    if (entry["time"] != 100) {
        logger.debug("History entry time should be 100");
        return false;
    }
    if (entry["half"] != 1) {
        logger.debug("History entry half should be 1");
        return false;
    }

    // Test adding 2 more points (Conversion)
    view.setMatchTime(120);
    view.addScoreHome(2);

    if (view.getScoreHome() != 7) {
        logger.debug("Home score should be 7 after conversion");
        return false;
    }

    if (history.size() != 2) {
        logger.debug("History size should be 2");
        return false;
    }

    entry = history[1];
    if (entry["points"] != 2) {
        logger.debug("Second history entry points should be 2");
        return false;
    }
    if (entry["time"] != 120) {
        logger.debug("Second history entry time should be 120");
        return false;
    }

    return true;
}

(:test)
function testAddScoreHomeAccumulation(logger) {
    var view = new RugbyRefView();

    view.addScoreHome(5); // Try
    view.addScoreHome(2); // Conversion
    view.addScoreHome(3); // Penalty

    if (view.getScoreHome() != 10) {
        logger.debug("Home score should be 10 after multiple scores (5+2+3)");
        return false;
    }

    var history = view.getScoreHistory();
    if (history.size() != 3) {
        logger.debug("History size should be 3 after 3 scores");
        return false;
    }

    return true;
}

(:test)
function testMatchTimerAlertLogic(logger) {
    var view = new RugbyRefView();
    var duration = 100;
    view.setHalfDuration(duration);

    // Test Case 1: Normal boundary condition
    view.setMatchTime(duration - 1);
    view.setMatchRunning(true);
    view.onTimerTick(); // Should increment to duration and alert

    if (!view.isHalfTimeAlerted()) {
        logger.debug("Should have alerted at match time == duration");
        return false;
    }

    // Reset for next case
    view.resetMatch();
    view.setHalfDuration(duration);

    // Test Case 2: Skip condition (Vulnerability fix verification)
    view.setMatchTime(duration + 5);
    view.setMatchRunning(true);
    view.onTimerTick(); // Should increment and alert

    if (!view.isHalfTimeAlerted()) {
        logger.debug("Should have alerted even if match time > duration (skip vulnerability)");
        return false;
    }

    return true;
}

(:test)
function testBreakTimerAlertLogic(logger) {
    var view = new RugbyRefView();
    var duration = 50;
    view.setBreakDuration(duration);
    view.setHalfTimeBreak(true);

    // Test Case 1: Skip condition for break timer
    view.setBreakTime(duration + 2);
    view.onTimerTick();

    if (!view.isBreakTimeAlerted()) {
        logger.debug("Should have alerted for break time skip");
function testMultipleSinBins(logger) {
    var view = new RugbyRefView();

    // Initial state: 0 sin bins
    if (view.getSinBins().size() != 0) {
        logger.debug("Initial sin bins should be 0");
        return false;
    }

    // Add first sin bin
    view.startSinBin();
    if (view.getSinBins().size() != 1) {
        logger.debug("Should have 1 sin bin");
        return false;
    }

    // Add second sin bin
    view.startSinBin();
    if (view.getSinBins().size() != 2) {
        logger.debug("Should have 2 sin bins");
        return false;
    }

    // Test removal
    view.stopSinBin();
    if (view.getSinBins().size() != 1) {
        logger.debug("Should have 1 sin bin after stop");
        return false;
    }

    return true;
}
