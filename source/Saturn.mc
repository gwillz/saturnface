
module Saturn {

    enum Theme {
        THEME_COMFY = 1,
        THEME_SUPER_THIN = 2,
        THEME_COMPACT = 3,
    }

    enum Ring {
        RING_MERIDIEM = 1024,
        RING_HOURS    = 2048,
        RING_MINUTES  = 4096,
        RING_SECONDS  = 8192,
    }

    enum Data {
        DATA_NONE     = 0x0,
        DATA_BATTERY  = 0x2,
        DATA_STEPS    = 0x4,
        DATA_HEART    = 0x8,
        DATA_ALTITUDE = 0x10,
        DATA_HEADING  = 0x20,
        DATA_SPEED    = 0x40,
    }
}
