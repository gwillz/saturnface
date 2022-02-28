import Toybox.WatchUi;
import Toybox.Graphics;

class SaturnRing extends WatchUi.Drawable {

    // No. of segments.
    private var _segments as Integer;

    // Segment gap, in degrees.
    private var _gap as Integer;

    // Segment size, in degrees.
    private var _arc as Integer;

    // Current segment.
    private var _position as Integer;

    // Only show the active segment.
    private var _active as Boolean;

    // Percent (0-1).
    private var _width as Float;

    // Percent (0-1).
    private var _radius as Float;

    // Segment colour.
    private var _color as Graphics.ColorType;


    function initialize(params as Dictionary) {
        Drawable.initialize(params);

        _segments = 360;
        _gap = 0;
        _active = false;
        _width = 0.01;
        _radius = 1.0;
        _color = Graphics.COLOR_BLUE;

        if (params.hasKey(:segments)) {
            self._segments = params.get(:segments);
        }

        if (params.hasKey(:gap)) {
            self._gap = params.get(:gap) / 2;
        }

        if (params.hasKey(:active)) {
            self._active = params.get(:active) as Boolean;
        }

        if (params.hasKey(:width)) {
            self._width = params.get(:width) / 100.0;
        }

        if (params.hasKey(:radius)) {
            self._radius = params.get(:radius) / 100.0;
        }

        // Not sure how this converts from strings...
        if (params.hasKey(:color)) {
            self._color = params.get(:color) as Graphics.ColorType;
        }

        self._position = 0;
        self._arc = 360 / self._segments;

        System.println("SaturnRing: " + self._segments + " segments, " + self._gap + " gap, " + self._width + " width, " + self._radius + " radius, " + self._active + " active, " + self._color + " color");
    }


    function setPosition(position as Integer) {
        self._position = (position % self._segments) || self._segments;
    }


    function draw(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        // From the center.
        var xCenter = width / 2;
        var yCenter = height / 2;

        // 95% of the face.
        var radius = (yCenter > xCenter ? xCenter : yCenter) * self._radius;

        // 3% width.
        dc.setPenWidth(width * self._width);
        dc.setColor(self._color, Graphics.COLOR_TRANSPARENT);

        if (self._active) {
            var segment = self.getSegment(self._position);
            dc.drawArc(xCenter, yCenter, radius, Graphics.ARC_CLOCKWISE, segment[:start], segment[:end]);
        }
        else {
            for (var position = 0; position < self._position; position++) {
                var segment = self.getSegment(position);
                dc.drawArc(xCenter, yCenter, radius, Graphics.ARC_CLOCKWISE, segment[:start], segment[:end]);
            }
        }
    }


    protected function getSegment(position as Integer) as Dictionary<String, Integer> {
        var offset = 90 - position * self._arc;
        var start = (offset - self._gap) % 360;
        var end = (offset - self._arc + self._gap) % 360;

        return {
            :start => start,
            :end => end,
        };
    }
}
