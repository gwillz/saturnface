import Toybox.WatchUi;
import Toybox.Graphics;

class SaturnRing extends WatchUi.Drawable {

    private var _group as Integer;

    // No. of segments.
    private var _segments as Integer;

    // Segment gap, in degrees.
    private var _gap as Integer;

    // Segment size, in degrees - determined by _segments.
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

    // Show or hide.
    private var _visible as Boolean;

    // Theming, this sets the gap/width/radius.
    private var _theme as Saturn.Theme;


    function initialize(params as Dictionary) {
        Drawable.initialize(params);

        _segments = params.get(:segments);
        _group = params.get(:group);

        _visible = true;
        _active = false;

        if (params.hasKey(:active)) {
            _active = params.get(:active) as Boolean;
        }

        // Theme things.
        _theme = Saturn.COMFY;
        _color = Graphics.COLOR_WHITE;
        _gap = 0;
        _width = 0.01;
        _radius = 1.0;

        self._position = 0;
        self._arc = 360 / self._segments;
    }


    function setTheme(theme as Saturn.Theme) as Void {
        self._theme = theme;

        switch (_theme | _group) {

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

            case Saturn.COMFY | Saturn.SECONDS:
                self._width = 0.05;
                self._radius = 0.50;
                self._gap = 0;
                break;

            case Saturn.COMFY | Saturn.MERIDIEM:
                self._width = 0.05;
                self._radius = 0.50;
                self._gap = 0;
                break;

            case Saturn.SUPER_THIN | Saturn.HOURS:
                self._width = 0.01;
                self._radius = 0.90;
                self._gap = 0;
                break;

            case Saturn.SUPER_THIN | Saturn.MINUTES:
                self._width = 0.01;
                self._radius = 0.70;
                self._gap = 0;
                break;

            case Saturn.SUPER_THIN | Saturn.SECONDS:
                self._width = 0.01;
                self._radius = 0.50;
                self._gap = 0;
                break;

            case Saturn.SUPER_THIN | Saturn.MERIDIEM:
                self._width = 0.01;
                self._radius = 0.50;
                self._gap = 0;
                break;

            case Saturn.COMPACT | Saturn.HOURS:
                self._width = 0.03;
                self._radius = 0.97;
                self._gap = 1;
                break;

            case Saturn.COMPACT | Saturn.MINUTES:
                self._width = 0.10;
                self._radius = 0.80;
                self._gap = 1;
                break;

            case Saturn.COMPACT | Saturn.SECONDS:
                self._width = 0.03;
                self._radius = 0.64;
                self._gap = 1;
                break;

            case Saturn.COMPACT | Saturn.MERIDIEM:
                self._width = 0.03;
                self._radius = 0.64;
                self._gap = 0;
                break;
        }
    }


    function setColor(color as Graphics.ColorType) as Void {
        self._color = color;
    }


    function setVisible(visible as Boolean) as Void {
        self._visible = visible;
    }


    function setPosition(position as Integer) as Void {
        self._position = (position % self._segments) || self._segments;
    }


    function draw(dc as Dc) as Void {
        if (!_visible) {
            dc.clear();
            return;
        }

        var width = dc.getWidth();
        var height = dc.getHeight();

        // From the center.
        var xCenter = width / 2;
        var yCenter = height / 2;

        var radius = (yCenter > xCenter ? xCenter : yCenter) * self._radius;

        dc.setPenWidth(width * self._width);
        dc.setColor(self._color, Graphics.COLOR_TRANSPARENT);

        // Draw just one segment.
        if (self._active) {
            var segment = self.getSegment(self._position);
            dc.drawArc(xCenter, yCenter, radius, Graphics.ARC_CLOCKWISE, segment[:start], segment[:end]);
        }
        // Draw lots of segments.
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
