using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class RugbyRefDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        // Start/Stop timer with SELECT button
        var view = Ui.View.findDrawableById("MainView");
        if (view != null) {
            view.toggleTimer();
        }
        return true;
    }
    
    function onNextPage() {
        // Score for home team (DOWN button)
        var menu = new ScoreMenu(:home);
        Ui.pushView(menu, new ScoreMenuDelegate(:home), Ui.SLIDE_UP);
        return true;
    }
    
    function onPreviousPage() {
        // Score for away team (UP button)
        var menu = new ScoreMenu(:away);
        Ui.pushView(menu, new ScoreMenuDelegate(:away), Ui.SLIDE_DOWN);
        return true;
    }

    function onMenu() {
        var menu = new Rez.Menus.MainMenu();
        Ui.pushView(menu, new MainMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onBack() {
        // Allow back to exit
        return false;
    }
}

class MainMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var view = Ui.View.findDrawableById("MainView");
        if (view == null) {
            return;
        }
        
        if (item == :sin_bin_start) {
            view.startSinBin();
        } else if (item == :sin_bin_stop) {
            view.stopSinBin();
        } else if (item == :half_time) {
            view.startHalfTime();
        } else if (item == :finish_match) {
            view.finishMatch();
        } else if (item == :reset) {
            view.resetMatch();
        } else if (item == :undo_score) {
            view.undoLastScore();
        } else if (item == :kick_conversion) {
            view.startKickTimer(:conversion);
        } else if (item == :kick_penalty) {
            view.startKickTimer(:penalty);
        } else if (item == :kick_stop) {
            view.stopKickTimer();
        } else if (item == :settings) {
            var settingsView = new SettingsMenu();
            Ui.pushView(settingsView, new SettingsMenuDelegate(), Ui.SLIDE_UP);
        }
    }
}

class ScoreMenu extends Ui.Menu2 {
    function initialize(team) {
        Menu2.initialize({:title=>(team == :home ? "Home Score" : "Away Score")});
        
        addItem(new Ui.MenuItem("Try (5 pts)", null, :try, {}));
        addItem(new Ui.MenuItem("Conversion (2 pts)", null, :conversion, {}));
        addItem(new Ui.MenuItem("Penalty (3 pts)", null, :penalty, {}));
        addItem(new Ui.MenuItem("Drop Goal (3 pts)", null, :drop, {}));
    }
}

class ScoreMenuDelegate extends Ui.Menu2InputDelegate {
    private var mTeam;
    
    function initialize(team) {
        Menu2InputDelegate.initialize();
        mTeam = team;
    }

    function onSelect(item) {
        var view = Ui.View.findDrawableById("MainView");
        if (view == null) {
            return;
        }
        
        var points = 0;
        var id = item.getId();
        
        if (id == :try) {
            points = 5;
        } else if (id == :conversion) {
            points = 2;
        } else if (id == :penalty or id == :drop) {
            points = 3;
        }
        
        if (mTeam == :home) {
            view.addScoreHome(points);
        } else {
            view.addScoreAway(points);
        }
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
