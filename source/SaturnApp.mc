import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SaturnApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new SaturnView() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as SaturnApp {
    return Application.getApp() as SaturnApp;
}