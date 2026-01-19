using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Attention as Attention;
using Toybox.Application.Storage as Storage;

class RugbyRefView extends Ui.View {

    // Match state
    private var mMatchTime = 0;          // seconds
    private var mMatchRunning = false;
    private var mHalf = 1;                // 1 or 2
    private var mScoreHome = 0;
    private var mScoreAway = 0;
    private var mHalfTimeBreak = false;  // tracking half-time break
    private var mBreakTime = 0;          // seconds in break
    private var mMatchFinished = false;  // match completed
    private var mStoppedTime = 0;        // seconds stopped (for 60s reminder)
    private var mHasVibrated60s = false; // prevent multiple vibrations
    
    // Score history for undo
    private var mScoreHistory = [];
    
    // Sin bin state
    private var mSinBinActive = false;
    private var mSinBinTime = 0;         // seconds remaining
    
    // Conversion/kick timer
    private var mKickTimerActive = false;
    private var mKickTimerTime = 0;      // seconds remaining
    private var mKickTimerType = :conversion; // :conversion or :penalty
    
    // Timer
    private var mTimer;
    
    // Settings (loaded from storage)
    private var mHalfDuration = 2400;     // 40 minutes default
    private var mSinBinDuration = 600;    // 10 minutes default
    private var mBreakDuration = 600;     // 10 minutes default
    private var mVibrateEnabled = true;
    private var mHomeColor = Gfx.COLOR_BLUE;
    private var mAwayColor = Gfx.COLOR_RED;
    private var mReminderEnabled = true;  // 60s reminder

    function initialize() {
        View.initialize();
        mTimer = new Timer.Timer();
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

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Match summary screen
        if (mMatchFinished) {
            drawMatchSummary(dc, width, height);
            return;
        }
        
        // Half-time break screen
        if (mHalfTimeBreak) {
            dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(width/2, height/4, Gfx.FONT_LARGE, "HALF TIME", Gfx.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            var breakTimeStr = formatTime(mBreakTime);
            dc.drawText(width/2, height/2, Gfx.FONT_NUMBER_HOT, breakTimeStr, Gfx.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.drawText(width/2, height * 0.7, Gfx.FONT_SMALL, "Break Time", Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(width/2, height - 20, Gfx.FONT_XTINY, "SELECT to start H2", Gfx.TEXT_JUSTIFY_CENTER);
            return;
        }
        
        // Draw match timer (large, center)
        var matchTimeStr = formatTime(mMatchTime);
        var halfStr = "H" + mHalf;
        
        // Show time over target if exceeded
        var timeColor = Gfx.COLOR_WHITE;
        if (mMatchTime >= mHalfDuration) {
            timeColor = Gfx.COLOR_YELLOW;
            var overtime = mMatchTime - mHalfDuration;
            matchTimeStr = matchTimeStr + " (+" + formatTime(overtime) + ")";
        }
        
        dc.setColor(timeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/3, Gfx.FONT_NUMBER_HOT, matchTimeStr, Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/3 - 30, Gfx.FONT_SMALL, halfStr, Gfx.TEXT_JUSTIFY_CENTER);
        
        // Draw start/stop indicator with 60s reminder
        if (mMatchRunning) {
            dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
            dc.drawText(width/2, height/3 + 40, Gfx.FONT_TINY, "RUNNING", Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
            var statusText = "PAUSED";
            if (mStoppedTime >= 60 && mReminderEnabled) {
                statusText = "PAUSED " + mStoppedTime.format("%d") + "s";
            }
            dc.drawText(width/2, height/3 + 40, Gfx.FONT_TINY, statusText, Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        // Draw scores with team colors
        dc.setColor(mHomeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/4, height * 0.7, Gfx.FONT_MEDIUM, mScoreHome.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(mAwayColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width * 3/4, height * 0.7, Gfx.FONT_MEDIUM, mScoreAway.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/4, height * 0.8, Gfx.FONT_TINY, "HOME", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * 3/4, height * 0.8, Gfx.FONT_TINY, "AWAY", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Draw kick timer if active (priority over sin bin)
        if (mKickTimerActive) {
            var kickColor = mKickTimerTime <= 10 ? Gfx.COLOR_RED : Gfx.COLOR_ORANGE;
            dc.setColor(kickColor, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(0, 0, width, 30);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            var kickTypeStr = mKickTimerType == :conversion ? "CONVERSION" : "PENALTY KICK";
            var kickStr = kickTypeStr + ": " + mKickTimerTime.format("%d") + "s";
            dc.drawText(width/2, 5, Gfx.FONT_TINY, kickStr, Gfx.TEXT_JUSTIFY_CENTER);
        } else if (mSinBinActive) {
            // Draw sin bin if active
            dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(0, 0, width, 30);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            var sinBinStr = "SIN BIN: " + formatTime(mSinBinTime);
            dc.drawText(width/2, 5, Gfx.FONT_TINY, sinBinStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        // Draw menu hint
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height - 20, Gfx.FONT_XTINY, "MENU for more", Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    private function drawMatchSummary(dc, width, height) {
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, 10, Gfx.FONT_MEDIUM, "FULL TIME", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Final score
        dc.setColor(mHomeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/3, height/3, Gfx.FONT_NUMBER_HOT, mScoreHome.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/3, Gfx.FONT_NUMBER_HOT, "-", Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(mAwayColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width * 2/3, height/3, Gfx.FONT_NUMBER_HOT, mScoreAway.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        // Team labels
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/3, height/3 + 35, Gfx.FONT_TINY, "HOME", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * 2/3, height/3 + 35, Gfx.FONT_TINY, "AWAY", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Match stats
        var h1Time = mHalf == 1 ? mMatchTime : mHalfDuration;
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height * 0.65, Gfx.FONT_SMALL, "Match Stats:", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width/2, height * 0.75, Gfx.FONT_TINY, "H1: " + formatTime(h1Time), Gfx.TEXT_JUSTIFY_CENTER);
        if (mHalf == 2) {
            dc.drawText(width/2, height * 0.82, Gfx.FONT_TINY, "H2: " + formatTime(mMatchTime), Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        dc.drawText(width/2, height - 20, Gfx.FONT_XTINY, "MENU to reset", Gfx.TEXT_JUSTIFY_CENTER);
    }

    function onHide() {
        mTimer.stop();
    }

    function toggleTimer() {
        // If in half-time break, start second half
        if (mHalfTimeBreak) {
            mHalfTimeBreak = false;
            mBreakTime = 0;
            mHalf = 2;
            mMatchTime = 0;
            Ui.requestUpdate();
            return;
        }
        
        if (mMatchRunning) {
            mMatchRunning = false;
            mStoppedTime = 0;
            mHasVibrated60s = false;
            mTimer.stop();
        } else {
            mMatchRunning = true;
            mStoppedTime = 0;
            mTimer.start(method(:onTimerTick), 1000, true);
        }
        Ui.requestUpdate();
    }
    
    function onTimerTick() {
        if (mHalfTimeBreak) {
            mBreakTime++;
            if (mBreakTime == mBreakDuration) {
                vibrate();
            }
        } else if (mMatchRunning) {
            mMatchTime++;
            
            // Check if half is over (only vibrate once)
            if (mMatchTime == mHalfDuration) {
                vibrate();
            }
        } else {
            // Timer stopped - track for 60s reminder
            mStoppedTime++;
            if (mStoppedTime == 60 && mReminderEnabled && !mHasVibrated60s) {
                vibrateShort();
                mHasVibrated60s = true;
            }
        }
        
        // Update sin bin
        if (mSinBinActive) {
            mSinBinTime--;
            if (mSinBinTime <= 0) {
                mSinBinActive = false;
                vibrate();
            }
        }
        
        // Update kick timer
        if (mKickTimerActive) {
            mKickTimerTime--;
            if (mKickTimerTime <= 0) {
                mKickTimerActive = false;
                vibrate();
            } else if (mKickTimerTime == 10) {
                vibrateShort(); // Warning at 10s
            }
        }
        
        Ui.requestUpdate();
    }
    
    function startSinBin() {
        mSinBinActive = true;
        mSinBinTime = mSinBinDuration;
        vibrate();
        Ui.requestUpdate();
    }
    
    function stopSinBin() {
        mSinBinActive = false;
        Ui.requestUpdate();
    }
    
    function addScoreHome(points) {
        // Save to history for undo
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
        // Save to history for undo
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
            return false;
        }
        
        var lastScore = mScoreHistory[mScoreHistory.size() - 1];
        if (lastScore["team"] == :home) {
            mScoreHome -= lastScore["points"];
        } else {
            mScoreAway -= lastScore["points"];
        }
        
        mScoreHistory = mScoreHistory.slice(0, mScoreHistory.size() - 1);
        Ui.requestUpdate();
        return true;
    }
    
    function startHalfTime() {
        mHalfTimeBreak = true;
        mBreakTime = 0;
        mMatchRunning = false;
        // Keep timer running to track break
        if (!mTimer.isRunning()) {
            mTimer.start(method(:onTimerTick), 1000, true);
        }
        vibrate();
        Ui.requestUpdate();
    }
    
    function finishMatch() {
        mMatchFinished = true;
        mMatchRunning = false;
        mTimer.stop();
        vibrate();
        Ui.requestUpdate();
    }
    
    function resetMatch() {
        mMatchTime = 0;
        mHalf = 1;
        mScoreHome = 0;
        mScoreAway = 0;
        mMatchRunning = false;
        mSinBinActive = false;
        mHalfTimeBreak = false;
        mBreakTime = 0;
        mMatchFinished = false;
        mStoppedTime = 0;
        mHasVibrated60s = false;
        mScoreHistory = [];
        mKickTimerActive = false;
        mTimer.stop();
        Ui.requestUpdate();
    }
    
    function startKickTimer(kickType) {
        mKickTimerActive = true;
        mKickTimerType = kickType;
        mKickTimerTime = kickType == :conversion ? 60 : 90;
        
        // Start timer if not running
        if (!mTimer.isRunning()) {
            mTimer.start(method(:onTimerTick), 1000, true);
        }
        vibrateShort();
        Ui.requestUpdate();
    }
    
    function stopKickTimer() {
        mKickTimerActive = false;
        Ui.requestUpdate();
    }
    
    function getSettings() {
        return {
            "halfDuration" => mHalfDuration,
            "sinBinDuration" => mSinBinDuration,
            "breakDuration" => mBreakDuration,
            "vibrateEnabled" => mVibrateEnabled
        };
    }
    
    function updateSettings(settings) {
        if (settings.hasKey("halfDuration")) {
            mHalfDuration = settings["halfDuration"];
        }
        if (settings.hasKey("sinBinDuration")) {
            mSinBinDuration = settings["sinBinDuration"];
        }
        if (settings.hasKey("breakDuration")) {
            mBreakDuration = settings["breakDuration"];
        }
        if (settings.hasKey("vibrateEnabled")) {
            mVibrateEnabled = settings["vibrateEnabled"];
        }
        Ui.requestUpdate();
    }
    
    private function formatTime(seconds) {
        var mins = seconds / 60;
        var secs = seconds % 60;
        return mins.format("%02d") + ":" + secs.format("%02d");
    }
    
    private function vibrate() {
        if (!mVibrateEnabled) {
            return;
        }
        
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
        if (!mVibrateEnabled) {
            return;
        }
        
        if (Attention has :vibrate) {
            var vibeData = [
                new Attention.VibeProfile(50, 100)
            ];
            Attention.vibrate(vibeData);
        }
    }
    
    function isTimerRunning() {
        return mMatchRunning or mHalfTimeBreak;
    }
    
    function isMatchFinished() {
        return mMatchFinished;
    }
}
