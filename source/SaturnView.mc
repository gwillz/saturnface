import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SaturnView extends WatchUi.WatchFace {

    private var _showSeconds as Boolean;
    private var _showDate as Boolean;
    private var _showTimer as Boolean;
    private var _dataType as Saturn.Data;
    private var _color as Graphics.ColorType;
    private var _theme as Saturn.Theme;
    private var _height as Number;

    private var _placing as Boolean;

    function initialize() {
        WatchFace.initialize();
        readSettings();
        _placing = true;
    }


    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        updateTheme();
        _height = dc.getHeight();
        placeLabels();
    }


    // Update the view
    function onUpdate(dc as Dc) as Void {
        var hours = View.findDrawableById("Hours") as SaturnRing;
        var minutes = View.findDrawableById("Minutes") as SaturnRing;
        var seconds = View.findDrawableById("Seconds") as SaturnRing;
        var meridiem = View.findDrawableById("Meridiem") as SaturnRing;
        var monthLabel = View.findDrawableById("MonthLabel") as Text;
        var dayLabel = View.findDrawableById("DayLabel") as Text;
        var timerLabel = View.findDrawableById("TimerLabel") as Text;
        var dataLabel = View.findDrawableById("DataLabel") as Text;

        var clockTime = System.getClockTime();
        var date = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        hours.setPosition(clockTime.hour);
        minutes.setPosition(clockTime.min);

        // Hide/show seconds or the meridiem ring.
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

        var timer = null;

        if (_showTimer) {
            var info = Activity.getActivityInfo();
            if (
                info != null
                and info.timerState == 3
                and info.timerTime != null
            ) {
                timer = formatTimer(info.timerTime);
                timerLabel.setText(timer);
            }
        }

        if (timer == null) {
            timerLabel.setText("");
        }

        if (_showDate and timer == null) {
            monthLabel.setText(date.month);
            dayLabel.setText(Lang.format("$1$ $2$", [
                date.day_of_week,
                date.day,
            ]));
        }
        else {
            monthLabel.setText("");
            dayLabel.setText("");
        }

        if (_dataType and timer == null) {
            var text = getDataText();
            dataLabel.setText(text);
        }
        else {
            dataLabel.setText("");
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        if (_placing) {
            placeLabels();
            _placing = false;
        }
    }


    function placeLabels() as Void {
        var timer = View.findDrawableById("TimerLabel") as Text;
        var month = View.findDrawableById("MonthLabel") as Text;
        var day = View.findDrawableById("DayLabel") as Text;
        var data = View.findDrawableById("DataLabel") as Text;

        if (_showDate) {
            var height = month.height * 0.8 + day.height * 0.8;

            if (_dataType) {
                data.setFont(Graphics.FONT_XTINY);
                height += data.height;
            }

            var y = (_height - height) / 2;
            month.setLocation(month.locX, y);

            y += month.height * 0.8;
            day.setLocation(day.locX, y);

            if (_dataType) {
                y += day.height * 1;
                data.setLocation(data.locX, y);
            }
        }
        else if (_dataType) {
            data.setFont(Graphics.FONT_LARGE);
            var y = (_height - data.height) / 2;
            data.setLocation(data.locX, y);
        }
    }


    function getDataText() as String {
        var info = Activity.getActivityInfo();
        var history = ActivityMonitor.getHistory();

        if (_dataType == Saturn.DATA_BATTERY) {
            var stats = System.getSystemStats();
            return stats.battery.format("%.0f") + "%";
        }

        if (_dataType == Saturn.DATA_STEPS) {
            if (history.size() == 0) {
                return "";
            }

            var steps = history[0].steps;

            if (steps == null) {
                return "...";
            }

            return steps.format("%d");
        }

        if (_dataType == Saturn.DATA_HEART) {
            if (info == null) {
                return "";
            }
            if (info.currentHeartRate == null) {
                return "...";
            }
            return info.currentHeartRate.format("%d");
        }

        if (_dataType == Saturn.DATA_ALTITUDE) {
            if (info == null) {
                return "";
            }
            if (info.altitude == null) {
                return "...";
            }
            return info.altitude.format("%d") + "m";
        }

        if (_dataType == Saturn.DATA_HEADING) {
            if (info == null) {
                return "";
            }
            if (info.currentHeading == null) {
                return "...";
            }
            return formatHeading(info.currentHeading);
        }

        if (_dataType == Saturn.DATA_SPEED) {
            if (info == null) {
                return "";
            }
            if (info.currentSpeed == null) {
                return "...";
            }
            return (info.currentSpeed * 3.6).format("%d") + "kph";
        }

        return "";
    }


    function formatHeading(radians as Float) as String {
        var segment = 0.392695; // 3.14156 / 8;

        radians += 3.1456;

        System.println("radians: " + radians);

        if (radians > segment * 15) {
            return "ESE";
        }

        if (radians > segment * 14) {
            return "SE";
        }

        if (radians > segment * 13) {
            return "SSE";
        }

        if (radians > segment * 12) {
            return "S";
        }

        if (radians > segment * 11) {
            return "SSW";
        }

        if (radians > segment * 10) {
            return "SW";
        }

        if (radians > segment * 9) {
            return "WSW";
        }

        if (radians > segment * 8) {
            return "W";
        }

        if (radians > segment * 8) {
            return "WNW";
        }

        if (radians > segment * 7) {
            return "NW";
        }

        if (radians > segment * 6) {
            return "NNW";
        }

        if (radians > segment * 5) {
            return "N";
        }

        if (radians > segment * 4) {
            return "NNE";
        }

        if (radians > segment * 3) {
            return "NE";
        }

        if (radians > segment * 2) {
            return "ENE";
        }

        if (radians > segment) {
            return "E";
        }

        return "??";
    }


    function formatTimer(msTime as Number) as String {
        var hourTime = msTime / 3600000;
        var minuteTime = msTime / 60000;
        var secondTime = msTime / 1000;

        var text = "";

        if (hourTime >= 1) {
            text += hourTime.format("%d") + ":";
        }

        text += minuteTime.format("%02d") + ":";
        text += secondTime.format("%02d");

        return text;
    }


    function readSettings() as Void {
        _showSeconds = getApp().getProperty("ShowSeconds") as Boolean;
        _showDate = getApp().getProperty("ShowDate") as Boolean;
        _showTimer = getApp().getProperty("ShowTimer") as Boolean;
        _dataType = getApp().getProperty("DataType") as Saturn.Data;
        _color = getApp().getProperty("Color") as Graphics.ColorType;
        _theme = getApp().getProperty("Theme") as Saturn.Theme;
    }


    function updateTheme() as Void {
        var meridiem = View.findDrawableById("Meridiem") as SaturnRing;
        var hours = View.findDrawableById("Hours") as SaturnRing;
        var minutes = View.findDrawableById("Minutes") as SaturnRing;
        var seconds = View.findDrawableById("Seconds") as SaturnRing;
        var timer = View.findDrawableById("TimerLabel") as Text;
        var month = View.findDrawableById("MonthLabel") as Text;
        var day = View.findDrawableById("DayLabel") as Text;
        var data = View.findDrawableById("DataLabel") as Text;

        meridiem.setColor(_color);
        meridiem.setTheme(_theme);

        hours.setColor(_color);
        hours.setTheme(_theme);

        minutes.setColor(_color);
        minutes.setTheme(_theme);

        seconds.setColor(_color);
        seconds.setTheme(_theme);

        timer.setColor(_color);
        month.setColor(_color);
        day.setColor(_color);
        data.setColor(_color);
    }


    function updateSettings() as Void {
        readSettings();
        updateTheme();
        _placing = true;
    }
}
