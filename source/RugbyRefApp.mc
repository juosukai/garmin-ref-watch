using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class RugbyRefApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        var view = new RugbyRefView();
        return [ view, new RugbyRefDelegate(view) ];
    }

}
