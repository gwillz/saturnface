import Toybox.WatchUi;
import Toybox.Graphics;

class HoursRing extends WatchUi.Drawable {

    // 30 degrees per hour.
    const ARC_HOUR = 30;

    // 6 degrees of gap, 3 per side.
    const ARC_SPACE = 3;

    private var _hour as Integer;


    function initialize(settings) {
        WatchUi.Drawable.initialize(settings);
        self._hour = 12;
    }


    function setHour(hour as Integer) {
        self._hour = (hour % 12) || 12;
    }


    function draw(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // From the center.
        var xCenter = width / 2;
        var yCenter = height / 2;

        // 95% of the face.
        var radius = (yCenter > xCenter ? xCenter : yCenter) * 0.95;

        // 3% width.
        dc.setPenWidth(width * 0.03);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

        for (var hour = 0; hour < self._hour; hour++) {
            var offset = 90 - hour * self.ARC_HOUR;
            var start = (offset - self.ARC_SPACE) % 360;
            var end = (offset - self.ARC_HOUR + self.ARC_SPACE) % 360;

            dc.drawArc(xCenter, yCenter, radius, Graphics.ARC_CLOCKWISE, start, end);
        }
    }
}
