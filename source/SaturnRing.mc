import Toybox.WatchUi;
import Toybox.Graphics;

class SaturnRing extends WatchUi.Drawable {

    private var _group as Integer;

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

        _segments = params.get(:segments);

        _group = params.get(:group);

        if (params.hasKey(:active)) {
            _active = params.get(:active) as Boolean;
        }
        else {
            _active = false;
        }

        readSettings();

        self._position = 0;
        self._arc = 360 / self._segments;

        System.println("SaturnRing: " + self._segments + " segments, " + self._gap + " gap, " + self._width + " width, " + self._radius + " radius, " + self._active + " active, " + self._color + " color");
    }


    function readSettings() as Void {
        _color = getApp().getProperty("Color") as Graphics.ColorType;

        var theme = getApp().getProperty("Theme") as Saturn.Theme;

        System.println("theme: " + theme + ", group: " + _group);

        switch (theme | _group) {

            case Saturn.COMFY | Saturn.HOURS:
                self._width = 0.05;
                self._radius = 0.90;
                self._gap = 3;
                break;

            case Saturn.COMFY | Saturn.MINUTES:
                self._width = 0.05;
                self._radius = 0.70;
                self._gap = 1;
                break;

            case Saturn.COMFY | Saturn.MERIDIEM:
                self._width = 0.05;
                self._radius = 0.50;
                self._gap = 0;
                break;

            case Saturn.SUPER_THIN | Saturn.HOURS:
                self._width = 0.01;
                self._radius = 0.85;
                self._gap = 1;
                break;

            case Saturn.SUPER_THIN | Saturn.MINUTES:
                self._width = 0.01;
                self._radius = 0.75;
                self._gap = 1;
                break;

            case Saturn.SUPER_THIN | Saturn.MERIDIEM:
                self._width = 0.01;
                self._radius = 0.65;
                self._gap = 0;
                break;

            case Saturn.COMPACT | Saturn.HOURS:
                self._width = 0.03;
                self._radius = 0.95;
                self._gap = 2;
                break;

            case Saturn.COMPACT | Saturn.MINUTES:
                self._width = 0.10;
                self._radius = 0.75;
                self._gap = 1;
                break;

            case Saturn.COMPACT | Saturn.MERIDIEM:
                self._width = 0.03;
                self._radius = 0.55;
                self._gap = 0;
                break;
        }
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
