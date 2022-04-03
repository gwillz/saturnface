import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SaturnApp extends Application.AppBase {

    private var _view as View;

    function initialize() {
        AppBase.initialize();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        _view = new SaturnView();
        return [ _view ] as Array<Views or InputDelegates>;
    }


    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        _view.updateSettings();
        WatchUi.requestUpdate();
    }

}

function getApp() as SaturnApp {
    return Application.getApp() as SaturnApp;
}
