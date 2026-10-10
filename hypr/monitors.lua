------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Built-in panel: AU Optronics 16" 16:10, 1920x1200, 340x220mm (~143 PPI).
-- Scale 1.0 -> native 1920x1200 (previously 1.25 -> 1536x960). 1.5 (the old
-- "auto" pick) gives only 1280x800, which is oversized for a 16" panel.
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60",
    position = "2880x720", -- right of the BenQ, bottom edges aligned
    scale    = 1,
})

-- BenQ RD280U 28" 3:2: on the left of the laptop. 3840x2560 at scale 4/3 is
-- 2880x1920 logical, hence the laptop's x of 2880 and y of 1920 - 1200 = 720.
-- The scale must divide the resolution evenly: 1.4 isn't valid here (Hyprland
-- falls back to 1.333); the nearest valid scales are 1.333 and 1.6.
hl.monitor({
    output   = "desc:BNQ BenQ RD280U B6S0011001Q",
    mode     = "3840x2560@60",
    position = "0x0",
    scale    = 4 / 3,
})

-- Fallback for anything else plugged in (external displays)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- BenQ RD280U: primary display whenever it's plugged in. Workspaces 1-4 live
-- on it (falling back to the laptop panel when it's absent), and it takes focus.
local primary = "desc:BNQ BenQ RD280U B6S0011001Q"

for i = 1, 4 do
    hl.workspace_rule({ workspace = tostring(i), monitor = primary })
end

-- Rules only place workspaces when they're created, so move existing ones on hotplug
hl.on("monitor.added", function()
    if not hl.get_monitor(primary) then return end
    for i = 1, 4 do
        hl.dispatch(hl.dsp.workspace.move({ workspace = tostring(i), monitor = primary }))
    end
    hl.dispatch(hl.dsp.focus({ monitor = primary }))
    -- Keep the BenQ at full brightness (DDC/CI via ddcutil + i2c-dev). The
    -- delay gives the monitor time to answer DDC after it's plugged in.
    hl.dispatch(hl.dsp.exec_cmd("sleep 3; ddcutil --sn B6S0011001Q setvcp 10 100"))
end)

-- Render XWayland apps at native resolution instead of upscaling them (blurry).
-- Toolkits that honour GDK_SCALE/QT scaling then handle sizing themselves.
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
