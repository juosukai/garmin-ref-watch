using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class RugbyRefDelegate extends Ui.BehaviorDelegate {

    private var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onSelect() {
        // Start/Stop timer with SELECT button
        mView.toggleTimer();
        return true;
    }
    
    function onNextPage() {
        // Penalty kick timer (DOWN button)
        mView.startKickTimer(:penalty);
        return true;
    }
    
    function onPreviousPage() {
        // Conversion timer (UP button)
        mView.startKickTimer(:conversion);
        return true;
    }

    function onMenu() {
        var menu = new Rez.Menus.MainMenu();
        Ui.pushView(menu, new MainMenuDelegate(mView), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack() {
        // Block exit while a match is in progress to prevent accidental loss
        if (mView.isMatchActive()) {
            return true;
        }
        // Allow exit when no match is running
        return false;
    }
}

class MainMenuDelegate extends Ui.MenuInputDelegate {

    private var mView;

    function initialize(view) {
        MenuInputDelegate.initialize();
        mView = view;
    }

    function onMenuItem(item) {
        if (item == :score_home) {
            var menu = new ScoreMenu(:home);
            Ui.pushView(menu, new ScoreMenuDelegate(mView, :home), Ui.SLIDE_UP);
        } else if (item == :score_away) {
            var menu = new ScoreMenu(:away);
            Ui.pushView(menu, new ScoreMenuDelegate(mView, :away), Ui.SLIDE_DOWN);
        } else if (item == :sin_bin_start) {
            mView.startSinBin();
        } else if (item == :sin_bin_stop) {
            mView.stopSinBin();
        } else if (item == :half_time) {
            mView.startHalfTime();
        } else if (item == :finish_match) {
            mView.finishMatch();
        } else if (item == :reset) {
            mView.resetMatch();
        } else if (item == :undo_score) {
            mView.undoLastScore();
        } else if (item == :kick_conversion) {
            mView.startKickTimer(:conversion);
        } else if (item == :kick_penalty) {
            mView.startKickTimer(:penalty);
        } else if (item == :kick_stop) {
            mView.stopKickTimer();
        } else if (item == :settings) {
            var settingsView = new SettingsMenu();
            Ui.pushView(settingsView, new SettingsMenuDelegate(mView), Ui.SLIDE_UP);
        } else if (item == :exit_app) {
            Sys.exit();
        }
    }
}

class ScoreMenu extends Ui.Menu2 {
    function initialize(team) {
        Menu2.initialize({:title=>(team == :home ? "Home Score" : "Away Score")});
        
        addItem(new Ui.MenuItem("Try (" + RugbyConstants.SCORE_TRY + " pts)", null, :try, {}));
        addItem(new Ui.MenuItem("Conversion (" + RugbyConstants.SCORE_CONVERSION + " pts)", null, :conversion, {}));
        addItem(new Ui.MenuItem("Penalty (" + RugbyConstants.SCORE_PENALTY + " pts)", null, :penalty, {}));
        addItem(new Ui.MenuItem("Drop Goal (" + RugbyConstants.SCORE_DROP_GOAL + " pts)", null, :drop, {}));
    }
}

class ScoreMenuDelegate extends Ui.Menu2InputDelegate {
    private var mTeam;
    private var mView;
    
    function initialize(view, team) {
        Menu2InputDelegate.initialize();
        mView = view;
        mTeam = team;
    }

    function onSelect(item) {
        var points = 0;
        var id = item.getId();
        
        if (id == :try) {
            points = RugbyConstants.SCORE_TRY;
        } else if (id == :conversion) {
            points = RugbyConstants.SCORE_CONVERSION;
        } else if (id == :penalty) {
            points = RugbyConstants.SCORE_PENALTY;
        } else if (id == :drop) {
            points = RugbyConstants.SCORE_DROP_GOAL;
        }
        
        mView.addScore(mTeam, points);
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
