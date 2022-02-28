import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SaturnView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();

        var meridiem = View.findDrawableById("Meridiem") as SaturnRing;
        meridiem.setPosition(clockTime.hour >= 12 ? 0 : 1);

        var hours = View.findDrawableById("Hours") as SaturnRing;
        hours.setPosition(clockTime.hour);

        var minutes = View.findDrawableById("Minutes") as SaturnRing;
        minutes.setPosition(clockTime.min);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

}
