import Toybox.WatchUi;
import Toybox.Graphics;

class MinutesRing extends WatchUi.Drawable {

    // 30 degrees per hour.
    const ARC_SIZE = 6;

    // 2 degrees of gap, 1 per side.
    const ARC_SPACE = 1;

    private var _minute as Integer;


    function initialize(settings) {
        WatchUi.Drawable.initialize(settings);
        self._minute = 0;
    }


    function setMinute(minute as Integer) {
        self._minute = (minute % 60) || 60;
    }


    function draw(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // From the center.
        var xCenter = width / 2;
        var yCenter = height / 2;

        // 95% of the face.
        var radius = (yCenter > xCenter ? xCenter : yCenter) * 0.75;

        // 3% width.
        dc.setPenWidth(width * 0.02);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

        for (var minute = 0; minute < self._minute; minute++) {
            var offset = 90 - minute * self.ARC_SIZE;
            var start = (offset - self.ARC_SPACE) % 360;
            var end = (offset - self.ARC_SIZE + self.ARC_SPACE) % 360;

            dc.drawArc(xCenter, yCenter, radius, Graphics.ARC_CLOCKWISE, start, end);
        }
    }
}
