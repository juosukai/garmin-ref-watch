using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Attention as Attention;
using Toybox.Application.Storage as Storage;
using Toybox.ActivityRecording;

class RugbyRefView extends Ui.View {

    // Match state
    private var mMatchTime = 0;          // seconds elapsed in current half
    private var mMatchRunning = false;
    private var mHalf = 1;               // 1 or 2
    private var mScoreHome = 0;
    private var mScoreAway = 0;
    private var mHalfTimeBreak = false;  // tracking half-time break
    private var mBreakTime = 0;          // seconds in break
    private var mMatchFinished = false;  // match completed
    private var mMatchStarted = false;   // has the match ever been started
    private var mStoppedTime = 0;        // seconds clock has been stopped
    private var mHasVibrated60s = false;  // prevent repeated 60s vibrations
    private var mH1FinalTime = 0;        // store H1 time when going to half-time
    
    // Score history for undo
    private var mScoreHistory;
    
    // Sin bin state
    private var mSinBins;                // Array of seconds remaining
    
    // Conversion/kick timer
    private var mKickTimerActive = false;
    private var mKickTimerTime = 0;      // seconds remaining
    private var mKickTimerType = :conversion; // :conversion or :penalty
    
    // Timer
    private var mTimer;
    private var mTimerMethod;
    private var mTimerRunning = false;
    
    // Activity Recording
    private var mSession;

    // Settings (loaded from storage)
    private var mHalfDuration = RugbyConstants.DEFAULT_HALF_DURATION;     // 40 minutes default
    private var mSinBinDuration = RugbyConstants.DEFAULT_SIN_BIN_DURATION;    // 10 minutes default
    private var mBreakDuration = RugbyConstants.DEFAULT_BREAK_DURATION;     // 10 minutes default
    private var mVibrateEnabled = true;
    private var mHomeColor = Gfx.COLOR_BLUE;
    private var mAwayColor = Gfx.COLOR_RED;
    private var mReminderEnabled = true;  // 60s reminder

    function initialize() {
        View.initialize();
        mTimer = new Timer.Timer();
        // Create delegate and cache the method bound to it to avoid circular reference (View -> Method -> View)
        var delegate = new TimerCallbackDelegate(self);
        mTimerMethod = delegate.method(:onTimerTick);
        mScoreHistory = [];
        mSinBins = [];
        loadSettings();
    }
    
    function loadSettings() {
        var halfDur = Storage.getValue("halfDuration");
        if (halfDur != null) { mHalfDuration = halfDur; }
        
        var sinBinDur = Storage.getValue("sinBinDuration");
        if (sinBinDur != null) { mSinBinDuration = sinBinDur; }
        
        var breakDur = Storage.getValue("breakDuration");
        if (breakDur != null) { mBreakDuration = breakDur; }
        
        var vibrate = Storage.getValue("vibrateEnabled");
        if (vibrate != null) { mVibrateEnabled = vibrate; }
        
        var homeColor = Storage.getValue("homeColor");
        if (homeColor != null) { mHomeColor = homeColor; }
        
        var awayColor = Storage.getValue("awayColor");
        if (awayColor != null) { mAwayColor = awayColor; }
        
        var reminder = Storage.getValue("reminderEnabled");
        if (reminder != null) { mReminderEnabled = reminder; }
    }

    function onShow() {
        // Restart the hardware timer if we need it (e.g. returning from a menu)
        ensureTimerState();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        
        // Match summary screen
        if (mMatchFinished) {
            drawMatchSummary(dc, width, height);
            return;
        }
        
        // Half-time break screen
        if (mHalfTimeBreak) {
            drawHalfTimeScreen(dc, width, height);
            return;
        }
        
        // --- Main match screen ---
        
        // Top banner: kick timer or sin bin
        drawTopBanner(dc, width);
        
        // Half indicator
        var halfStr = "H" + mHalf;
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height / 3 - 32, Gfx.FONT_SMALL, halfStr, Gfx.TEXT_JUSTIFY_CENTER);
        
        // Match timer (large, center)
        var matchTimeStr = formatTime(mMatchTime);
        var timeColor = Gfx.COLOR_WHITE;
        if (mMatchTime >= mHalfDuration) {
            timeColor = Gfx.COLOR_YELLOW;
            var overtime = mMatchTime - mHalfDuration;
            matchTimeStr = matchTimeStr + " +" + formatTime(overtime);
        }
        dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height / 3, Gfx.FONT_NUMBER_HOT, matchTimeStr, Gfx.TEXT_JUSTIFY_CENTER);
        
        // Running / Paused status
        if (mMatchRunning) {
            dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height / 3 + 42, Gfx.FONT_TINY, "RUNNING", Gfx.TEXT_JUSTIFY_CENTER);
        } else if (mMatchStarted) {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
            var statusText = "PAUSED";
            if (mStoppedTime > 0 && mReminderEnabled) {
                statusText = "PAUSED " + mStoppedTime.format("%d") + "s";
            }
            dc.drawText(centerX, height / 3 + 42, Gfx.FONT_TINY, statusText, Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height / 3 + 42, Gfx.FONT_TINY, "SELECT to start", Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        // Scores with team colors
        dc.setColor(mHomeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 4, height * 70 / 100, Gfx.FONT_MEDIUM, mScoreHome.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(mAwayColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width * 3 / 4, height * 70 / 100, Gfx.FONT_MEDIUM, mScoreAway.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 4, height * 80 / 100, Gfx.FONT_XTINY, "HOME", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * 3 / 4, height * 80 / 100, Gfx.FONT_XTINY, "AWAY", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Separator line between scores
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(centerX, height * 68 / 100, centerX, height * 85 / 100);
    }
    
    private function drawTopBanner(dc, width) {
        if (mKickTimerActive) {
            var kickColor = mKickTimerTime <= 10 ? Gfx.COLOR_RED : Gfx.COLOR_ORANGE;
            dc.setColor(kickColor, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(0, 0, width, 28);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            var kickTypeStr = mKickTimerType == :conversion ? "CONV" : "PEN KICK";
            var kickStr = kickTypeStr + ": " + mKickTimerTime.format("%d") + "s";
            dc.drawText(width / 2, 4, Gfx.FONT_TINY, kickStr, Gfx.TEXT_JUSTIFY_CENTER);
        } else if (mSinBins.size() > 0) {
            dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(0, 0, width, 28);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);

            var index = 0;
            if (mSinBins.size() > 1) {
                index = (Sys.getTimer() / 3000) % mSinBins.size();
            }
            var time = mSinBins[index];
            var sinBinStr = "SIN BIN (" + (index + 1) + "/" + mSinBins.size() + "): " + formatTime(time);
            if (mSinBins.size() == 1) {
                sinBinStr = "SIN BIN: " + formatTime(time);
            }
            dc.drawText(width / 2, 4, Gfx.FONT_TINY, sinBinStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
    
    private function drawHalfTimeScreen(dc, width, height) {
        var centerX = width / 2;
        
        // Score at half time
        dc.setColor(mHomeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 3, 15, Gfx.FONT_MEDIUM, mScoreHome.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, 15, Gfx.FONT_MEDIUM, "-", Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(mAwayColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width * 2 / 3, 15, Gfx.FONT_MEDIUM, mScoreAway.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height / 4 + 5, Gfx.FONT_LARGE, "HALF TIME", Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var breakTimeStr = formatTime(mBreakTime);
        dc.drawText(centerX, height / 2, Gfx.FONT_NUMBER_HOT, breakTimeStr, Gfx.TEXT_JUSTIFY_CENTER);
        
        var breakColor = mBreakTime >= mBreakDuration ? Gfx.COLOR_YELLOW : Gfx.COLOR_DK_GRAY;
        dc.setColor(breakColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 70 / 100, Gfx.FONT_SMALL, "Break", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, height - 22, Gfx.FONT_XTINY, "SELECT to start H2", Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    private function drawMatchSummary(dc, width, height) {
        var centerX = width / 2;
        
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, 12, Gfx.FONT_MEDIUM, "FULL TIME", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Final score
        dc.setColor(mHomeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 3, height / 3, Gfx.FONT_NUMBER_HOT, mScoreHome.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height / 3, Gfx.FONT_NUMBER_HOT, "-", Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(mAwayColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width * 2 / 3, height / 3, Gfx.FONT_NUMBER_HOT, mScoreAway.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        // Team labels
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width / 3, height / 3 + 36, Gfx.FONT_XTINY, "HOME", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * 2 / 3, height / 3 + 36, Gfx.FONT_XTINY, "AWAY", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Match stats
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 62 / 100, Gfx.FONT_TINY, "H1: " + formatTime(mH1FinalTime), Gfx.TEXT_JUSTIFY_CENTER);
        if (mHalf == 2) {
            dc.drawText(centerX, height * 72 / 100, Gfx.FONT_TINY, "H2: " + formatTime(mMatchTime), Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height - 22, Gfx.FONT_XTINY, "MENU to reset", Gfx.TEXT_JUSTIFY_CENTER);
    }

    function onHide() {
        // IMPORTANT: Do NOT stop the timer here!
        // onHide is called when menus are pushed on top of this view.
        // The match timer, sin bin, and kick timers must keep running
        // even while the user navigates menus.
    }

    // --- Timer management ---
    // The hardware timer drives ALL countdown/countup logic.
    // We keep it running whenever anything needs ticking, and stop
    // it only when the app is truly idle.
    
    private function ensureTimerState() {
        var needsTimer = mMatchRunning
            || mSinBins.size() > 0
            || mKickTimerActive
            || mHalfTimeBreak
            || (mMatchStarted && !mMatchRunning && !mMatchFinished);
        
        if (needsTimer && !mTimerRunning) {
            mTimer.start(mTimerMethod, 1000, true);
            mTimerRunning = true;
        } else if (!needsTimer && mTimerRunning) {
            mTimer.stop();
            mTimerRunning = false;
        }
    }

    function createSession() {
        return ActivityRecording.createSession({
            :name => "Rugby Referee",
            :sport => ActivityRecording.SPORT_GENERIC,
            :subSport => ActivityRecording.SUB_SPORT_MATCH
        });
    }

    function toggleTimer() {
        // If in half-time break, start second half
        if (mHalfTimeBreak) {
            mHalfTimeBreak = false;
            mBreakTime = 0;
            mHalf = 2;
            mMatchTime = 0;
            mMatchRunning = false;
            ensureTimerState();
            Ui.requestUpdate();
            return;
        }
        
        // Ignore if match is finished
        if (mMatchFinished) {
            return;
        }
        
        if (mMatchRunning) {
            // Pause the match
            mMatchRunning = false;
            mStoppedTime = 0;
            mHasVibrated60s = false;
        } else {
            // Start / resume the match
            mMatchRunning = true;
            mMatchStarted = true;
            mStoppedTime = 0;

            // Start activity recording if this is the first start
            if (mSession == null) {
                mSession = createSession();
                mSession.start();
            }
        }
        
        ensureTimerState();
        Ui.requestUpdate();
    }
    
    function onTimerTick() {
        // Half-time break counter
        if (mHalfTimeBreak) {
            mBreakTime++;
            if (mBreakTime == mBreakDuration) {
                vibrate();
            }
        }
        
        // Match clock
        if (mMatchRunning) {
            mMatchTime++;
            if (mMatchTime == mHalfDuration) {
                vibrate();
            }
        } else if (mMatchStarted && !mMatchFinished && !mHalfTimeBreak) {
            // Clock is stopped mid-match: track for 60s reminder
            mStoppedTime++;
            if (mStoppedTime == RugbyConstants.PAUSE_REMINDER_TIME && mReminderEnabled && !mHasVibrated60s) {
                vibrateShort();
                mHasVibrated60s = true;
            }
        }
        
        // Sin bin countdown (only ticks during playing time)
        if (mMatchRunning && mSinBins.size() > 0) {
            var newSinBins = [];
            var vibrated = false;
            for (var i = 0; i < mSinBins.size(); i++) {
                var t = mSinBins[i];
                t--;
                if (t > 0) {
                    newSinBins.add(t);
                } else if (!vibrated) {
                    vibrate();
                    vibrated = true;
                }
            }
            mSinBins = newSinBins;
        }
        
        // Kick timer countdown
        if (mKickTimerActive) {
            mKickTimerTime--;
            if (mKickTimerTime <= 0) {
                mKickTimerActive = false;
                vibrate();
            } else if (mKickTimerTime == RugbyConstants.KICK_TIMER_WARNING) {
                vibrateShort();
            }
        }
        
        ensureTimerState();
        Ui.requestUpdate();
    }
    
    // --- Score management ---
    
    function addScoreHome(points) {
        mScoreHistory.add({
            "team" => :home,
            "points" => points,
            "time" => mMatchTime,
            "half" => mHalf
        });
        mScoreHome += points;
        Ui.requestUpdate();
    }
    
    function addScoreAway(points) {
        mScoreHistory.add({
            "team" => :away,
            "points" => points,
            "time" => mMatchTime,
            "half" => mHalf
        });
        mScoreAway += points;
        Ui.requestUpdate();
    }
    
    function undoLastScore() {
        if (mScoreHistory.size() == 0) {
            return;
        }
        
        var lastScore = mScoreHistory[mScoreHistory.size() - 1];
        if (lastScore["team"] == :home) {
            mScoreHome -= lastScore["points"];
        } else {
            mScoreAway -= lastScore["points"];
        }
        
        mScoreHistory.remove(lastScore);
        Ui.requestUpdate();
    }
    
    // --- Match flow ---
    
    function startSinBin() {
        mSinBins.add(mSinBinDuration);
        ensureTimerState();
        vibrate();
        Ui.requestUpdate();
    }
    
    function stopSinBin() {
        if (mSinBins.size() > 0) {
            var minTime = mSinBins[0];
            for (var i = 1; i < mSinBins.size(); i++) {
                if (mSinBins[i] < minTime) {
                    minTime = mSinBins[i];
                }
            }
            mSinBins.remove(minTime);
        }
        ensureTimerState();
        Ui.requestUpdate();
    }
    
    function startKickTimer(kickType) {
        mKickTimerActive = true;
        mKickTimerType = kickType;
        mKickTimerTime = kickType == :conversion ? RugbyConstants.KICK_TIMER_CONVERSION : RugbyConstants.KICK_TIMER_PENALTY;
        ensureTimerState();
        vibrateShort();
        Ui.requestUpdate();
    }
    
    function stopKickTimer() {
        mKickTimerActive = false;
        ensureTimerState();
        Ui.requestUpdate();
    }
    
    function startHalfTime() {
        mH1FinalTime = mMatchTime;
        mHalfTimeBreak = true;
        mBreakTime = 0;
        mMatchRunning = false;
        ensureTimerState();
        vibrate();
        Ui.requestUpdate();
    }
    
    function finishMatch() {
        if (mHalf == 1) {
            mH1FinalTime = mMatchTime;
        }
        mMatchFinished = true;
        mMatchRunning = false;
        mKickTimerActive = false;
        mTimer.stop();
        mTimerRunning = false;
        vibrate();

        // Save recording
        if (mSession != null) {
            if (mSession.isRecording()) {
                mSession.stop();
            }
            mSession.save();
            mSession = null;
        }

        Ui.requestUpdate();
    }
    
    function resetMatch() {
        mMatchTime = 0;
        mHalf = 1;
        mScoreHome = 0;
        mScoreAway = 0;
        mMatchRunning = false;
        mMatchStarted = false;
        mSinBins = [];
        mHalfTimeBreak = false;
        mBreakTime = 0;
        mMatchFinished = false;
        mStoppedTime = 0;
        mHasVibrated60s = false;
        mH1FinalTime = 0;
        mScoreHistory = [];
        mKickTimerActive = false;
        mTimer.stop();
        mTimerRunning = false;

        // Discard recording if active
        if (mSession != null) {
            if (mSession.isRecording()) {
                mSession.stop();
            }
            mSession.discard();
            mSession = null;
        }

        Ui.requestUpdate();
    }
    
    // --- Helpers ---
    
    private function formatTime(seconds) {
        var mins = seconds / 60;
        var secs = seconds % 60;
        return mins.format("%02d") + ":" + secs.format("%02d");
    }
    
    private function vibrate() {
        if (!mVibrateEnabled) { return; }
        if (Attention has :vibrate) {
            var vibeData = [
                new Attention.VibeProfile(50, 200),
                new Attention.VibeProfile(0, 100),
                new Attention.VibeProfile(50, 200)
            ];
            Attention.vibrate(vibeData);
        }
    }
    
    private function vibrateShort() {
        if (!mVibrateEnabled) { return; }
        if (Attention has :vibrate) {
            var vibeData = [
                new Attention.VibeProfile(50, 100)
            ];
            Attention.vibrate(vibeData);
        }
    }
    
    function isMatchFinished() {
        return mMatchFinished;
    }
    
    function isMatchActive() {
        return mMatchStarted && !mMatchFinished;
    }

    (:test)
    function getScoreHome() {
        return mScoreHome;
    }

    (:test)
    function getScoreAway() {
        return mScoreAway;
    }

    (:test)
    function getScoreHistory() {
        return mScoreHistory;
    }

    (:test)
    function setMatchTime(time) {
        mMatchTime = time;
    }

    (:test)
    function setHalf(half) {
        mHalf = half;
    }

    (:test)
    function getSinBins() {
        return mSinBins;
    }
}

class TimerCallbackDelegate {
    private var mView;

    function initialize(view) {
        mView = view.weak();
    }

    function onTimerTick() {
        if (mView.stillAlive()) {
            mView.get().onTimerTick();
        }
    }
}
