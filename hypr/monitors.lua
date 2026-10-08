------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Built-in panel: AU Optronics 16" 16:10, 1920x1200, 340x220mm (~143 PPI).
-- Scale 1.25 -> 1536x960 logical (~115 effective PPI). 1.5 (the old "auto"
-- pick) gives only 1280x800, which is oversized for a 16" panel.
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60",
    position = "0x0",
    scale    = 1.25,
})

-- Fallback for anything else plugged in (external displays)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Render XWayland apps at native resolution instead of upscaling them (blurry).
-- Toolkits that honour GDK_SCALE/QT scaling then handle sizing themselves.
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
