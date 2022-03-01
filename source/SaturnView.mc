import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SaturnView extends WatchUi.WatchFace {

    private var _showSeconds as Boolean;
    private var _showDate as Boolean;

    function initialize() {
        WatchFace.initialize();
    }


    // Load your resources here
    function onLayout(dc as Dc) as Void {
        _showSeconds = getApp().getProperty("ShowSeconds") as Boolean;
        _showDate = getApp().getProperty("ShowDate") as Boolean;

        setLayout(Rez.Layouts.WatchFace(dc));
    }


    // Update the view
    function onUpdate(dc as Dc) as Void {

        var hours = View.findDrawableById("Hours") as SaturnRing;
        var minutes = View.findDrawableById("Minutes") as SaturnRing;
        var seconds = View.findDrawableById("Seconds") as SaturnRing;
        var meridiem = View.findDrawableById("Meridiem") as SaturnRing;

        var clockTime = System.getClockTime();

        hours.setPosition(clockTime.hour);
        minutes.setPosition(clockTime.min);

        if (_showSeconds) {
            meridiem.setVisible(false);
            seconds.setVisible(true);

            seconds.setPosition(clockTime.sec);
        }
        else {
            meridiem.setVisible(true);
            seconds.setVisible(false);

            meridiem.setPosition(clockTime.hour >= 12 ? 0 : 1);
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }


    function updateConfigs() as Void {
        var meridiem = View.findDrawableById("Meridiem") as SaturnRing;
        var hours = View.findDrawableById("Hours") as SaturnRing;
        var minutes = View.findDrawableById("Minutes") as SaturnRing;
        var seconds = View.findDrawableById("Seconds") as SaturnRing;

        meridiem.readSettings();
        hours.readSettings();
        minutes.readSettings();
        seconds.readSettings();

        _showSeconds = getApp().getProperty("ShowSeconds") as Boolean;
        _showDate = getApp().getProperty("ShowDate") as Boolean;
    }

}
