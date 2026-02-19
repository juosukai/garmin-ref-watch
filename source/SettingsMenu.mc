using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application.Storage as Storage;

class SettingsMenu extends Ui.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Settings"});
        
        var vibrateOn = Storage.getValue("vibrateEnabled");
        if (vibrateOn == null) { vibrateOn = true; }
        var reminderOn = Storage.getValue("reminderEnabled");
        if (reminderOn == null) { reminderOn = true; }
        
        addItem(new Ui.MenuItem("Match Format", null, :match_format, {}));
        addItem(new Ui.MenuItem("Half Duration", null, :half_duration, {}));
        addItem(new Ui.MenuItem("Sin Bin Duration", null, :sin_bin_duration, {}));
        addItem(new Ui.MenuItem("Break Duration", null, :break_duration, {}));
        addItem(new Ui.MenuItem("Team Colors", null, :team_colors, {}));
        addItem(new Ui.MenuItem("Vibration", vibrateOn ? "ON" : "OFF", :vibrate, {}));
        addItem(new Ui.MenuItem("60s Reminder", reminderOn ? "ON" : "OFF", :reminder, {}));
    }
}

class SettingsMenuDelegate extends Ui.Menu2InputDelegate {
    private var mView;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        mView = view;
    }

    function onSelect(item) {
        var id = item.getId();
        
        if (id == :match_format) {
            var menu = new MatchFormatMenu();
            Ui.pushView(menu, new MatchFormatMenuDelegate(mView), Ui.SLIDE_UP);
        } else if (id == :half_duration) {
            var menu = new HalfDurationMenu();
            Ui.pushView(menu, new HalfDurationMenuDelegate(mView), Ui.SLIDE_UP);
        } else if (id == :sin_bin_duration) {
            var menu = new SinBinDurationMenu();
            Ui.pushView(menu, new SinBinDurationMenuDelegate(mView), Ui.SLIDE_UP);
        } else if (id == :break_duration) {
            var menu = new BreakDurationMenu();
            Ui.pushView(menu, new BreakDurationMenuDelegate(mView), Ui.SLIDE_UP);
        } else if (id == :team_colors) {
            var menu = new TeamColorsMenu();
            Ui.pushView(menu, new TeamColorsMenuDelegate(mView), Ui.SLIDE_UP);
        } else if (id == :vibrate) {
            toggleVibration();
            // Reopen settings to show updated state
            Ui.popView(Ui.SLIDE_IMMEDIATE);
            var menu = new SettingsMenu();
            Ui.pushView(menu, new SettingsMenuDelegate(mView), Ui.SLIDE_IMMEDIATE);
        } else if (id == :reminder) {
            toggleReminder();
            // Reopen settings to show updated state
            Ui.popView(Ui.SLIDE_IMMEDIATE);
            var menu = new SettingsMenu();
            Ui.pushView(menu, new SettingsMenuDelegate(mView), Ui.SLIDE_IMMEDIATE);
        }
    }
    
    private function toggleVibration() {
        var current = Storage.getValue("vibrateEnabled");
        if (current == null) {
            current = true;
        }
        Storage.setValue("vibrateEnabled", !current);
        
        if (mView != null) {
            mView.loadSettings();
        }
    }
    
    private function toggleReminder() {
        var current = Storage.getValue("reminderEnabled");
        if (current == null) {
            current = true;
        }
        Storage.setValue("reminderEnabled", !current);
        
        if (mView != null) {
            mView.loadSettings();
        }
    }
}

// Match Format Quick Presets
class MatchFormatMenu extends Ui.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Match Format"});
        
        addItem(new Ui.MenuItem("Rugby 7s (7 min)", null, :sevens, {}));
        addItem(new Ui.MenuItem("Rugby 10s (20 min)", null, :tens, {}));
        addItem(new Ui.MenuItem("Youth/12s (25 min)", null, :youth, {}));
        addItem(new Ui.MenuItem("12-a-side (30 min)", null, :twelve, {}));
        addItem(new Ui.MenuItem("Full 15s (40 min)", null, :fifteens, {}));
        addItem(new Ui.MenuItem("Custom...", null, :custom, {}));
    }
}

class MatchFormatMenuDelegate extends Ui.Menu2InputDelegate {
    private var mView;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        mView = view;
    }

    function onSelect(item) {
        var id = item.getId();
        var halfDur = RugbyConstants.DEFAULT_HALF_DURATION; // default 40 min
        var sinBinDur = RugbyConstants.DEFAULT_SIN_BIN_DURATION; // default 10 min
        
        if (id == :sevens) {
            halfDur = 420;   // 7 minutes
            sinBinDur = 120;  // 2 minutes
        } else if (id == :tens) {
            halfDur = 1200;   // 20 minutes
            sinBinDur = RugbyConstants.DEFAULT_SIN_BIN_DURATION;  // 10 minutes
        } else if (id == :youth) {
            halfDur = 1500;   // 25 minutes
            sinBinDur = 300;  // 5 minutes
        } else if (id == :twelve) {
            halfDur = 1800;   // 30 minutes
            sinBinDur = RugbyConstants.DEFAULT_SIN_BIN_DURATION;  // 10 minutes
        } else if (id == :fifteens) {
            halfDur = RugbyConstants.DEFAULT_HALF_DURATION;   // 40 minutes
            sinBinDur = RugbyConstants.DEFAULT_SIN_BIN_DURATION;  // 10 minutes
        } else if (id == :custom) {
            // Just return to settings menu
            Ui.popView(Ui.SLIDE_IMMEDIATE);
            return;
        }
        
        Storage.setValue("halfDuration", halfDur);
        Storage.setValue("sinBinDuration", sinBinDur);
        
        if (mView != null) {
            mView.loadSettings();
        }
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

// Half Duration Menu
class HalfDurationMenu extends Ui.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Half Duration"});
        
        addItem(new Ui.MenuItem("7 minutes", null, 420, {}));
        addItem(new Ui.MenuItem("10 minutes", null, 600, {}));
        addItem(new Ui.MenuItem("15 minutes", null, 900, {}));
        addItem(new Ui.MenuItem("20 minutes", null, 1200, {}));
        addItem(new Ui.MenuItem("25 minutes", null, 1500, {}));
        addItem(new Ui.MenuItem("30 minutes", null, 1800, {}));
        addItem(new Ui.MenuItem("35 minutes", null, 2100, {}));
        addItem(new Ui.MenuItem("40 minutes", null, RugbyConstants.DEFAULT_HALF_DURATION, {}));
    }
}

class HalfDurationMenuDelegate extends Ui.Menu2InputDelegate {
    private var mView;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        mView = view;
    }

    function onSelect(item) {
        var duration = item.getId();
        Storage.setValue("halfDuration", duration);
        
        if (mView != null) {
            mView.loadSettings();
        }
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

// Sin Bin Duration Menu
class SinBinDurationMenu extends Ui.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Sin Bin"});
        
        addItem(new Ui.MenuItem("2 minutes (7s)", null, 120, {}));
        addItem(new Ui.MenuItem("5 minutes (Youth)", null, 300, {}));
        addItem(new Ui.MenuItem("10 minutes (15s)", null, RugbyConstants.DEFAULT_SIN_BIN_DURATION, {}));
    }
}

class SinBinDurationMenuDelegate extends Ui.Menu2InputDelegate {
    private var mView;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        mView = view;
    }

    function onSelect(item) {
        var duration = item.getId();
        Storage.setValue("sinBinDuration", duration);
        
        if (mView != null) {
            mView.loadSettings();
        }
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

// Break Duration Menu
class BreakDurationMenu extends Ui.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Half-time Break"});
        
        addItem(new Ui.MenuItem("1 minute (7s)", null, 60, {}));
        addItem(new Ui.MenuItem("5 minutes", null, 300, {}));
        addItem(new Ui.MenuItem("10 minutes", null, RugbyConstants.DEFAULT_BREAK_DURATION, {}));
        addItem(new Ui.MenuItem("15 minutes", null, 900, {}));
    }
}

class BreakDurationMenuDelegate extends Ui.Menu2InputDelegate {
    private var mView;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        mView = view;
    }

    function onSelect(item) {
        var duration = item.getId();
        Storage.setValue("breakDuration", duration);
        
        if (mView != null) {
            mView.loadSettings();
        }
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

// Team Colors Menu
class TeamColorsMenu extends Ui.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Team Colors"});
        
        addItem(new Ui.MenuItem("Home Team Color", null, :home_color, {}));
        addItem(new Ui.MenuItem("Away Team Color", null, :away_color, {}));
    }
}

class TeamColorsMenuDelegate extends Ui.Menu2InputDelegate {
    private var mView;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        mView = view;
    }

    function onSelect(item) {
        var id = item.getId();
        
        if (id == :home_color) {
            var menu = new ColorPickerMenu(:home);
            Ui.pushView(menu, new ColorPickerMenuDelegate(mView, :home), Ui.SLIDE_UP);
        } else if (id == :away_color) {
            var menu = new ColorPickerMenu(:away);
            Ui.pushView(menu, new ColorPickerMenuDelegate(mView, :away), Ui.SLIDE_UP);
        }
    }
}

class ColorPickerMenu extends Ui.Menu2 {
    function initialize(team) {
        Menu2.initialize({:title=>(team == :home ? "Home Color" : "Away Color")});
        
        addItem(new Ui.MenuItem("Red", null, Gfx.COLOR_RED, {}));
        addItem(new Ui.MenuItem("Blue", null, Gfx.COLOR_BLUE, {}));
        addItem(new Ui.MenuItem("Green", null, Gfx.COLOR_GREEN, {}));
        addItem(new Ui.MenuItem("Yellow", null, Gfx.COLOR_YELLOW, {}));
        addItem(new Ui.MenuItem("Orange", null, Gfx.COLOR_ORANGE, {}));
        addItem(new Ui.MenuItem("Purple", null, Gfx.COLOR_PURPLE, {}));
        addItem(new Ui.MenuItem("Pink", null, Gfx.COLOR_PINK, {}));
        addItem(new Ui.MenuItem("White", null, Gfx.COLOR_WHITE, {}));
        addItem(new Ui.MenuItem("Lt Gray", null, Gfx.COLOR_LT_GRAY, {}));
        addItem(new Ui.MenuItem("Dk Gray", null, Gfx.COLOR_DK_GRAY, {}));
    }
}

class ColorPickerMenuDelegate extends Ui.Menu2InputDelegate {
    private var mTeam;
    private var mView;
    
    function initialize(view, team) {
        Menu2InputDelegate.initialize();
        mView = view;
        mTeam = team;
    }

    function onSelect(item) {
        var color = item.getId();
        
        if (mTeam == :home) {
            Storage.setValue("homeColor", color);
        } else {
            Storage.setValue("awayColor", color);
        }
        
        if (mView != null) {
            mView.loadSettings();
        }
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
