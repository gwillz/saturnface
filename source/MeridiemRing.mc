import Toybox.WatchUi;
import Toybox.Graphics;


class MeridiemRing extends WatchUi.Drawable {

    private var _meridiem as Integer;


    function initialize(settings) {
        WatchUi.Drawable.initialize(settings);
        self._meridiem = :am;
    }


    function setMeridiem(meridiem as Integer) {
        self._meridiem = meridiem;
    }


    function draw(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // From the center.
        var xCenter = width / 2;
        var yCenter = height / 2;

        // 55% of the face.
        var radius = (yCenter > xCenter ? xCenter : yCenter) * 0.55;

        var direction =
            self._meridiem == :am
            ? Graphics.ARC_COUNTER_CLOCKWISE
            : Graphics.ARC_CLOCKWISE;

        // 2% width.
        dc.setPenWidth(width * 0.02);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(xCenter, yCenter, radius, direction, 90, 270);
    }
}
