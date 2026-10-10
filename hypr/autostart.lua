-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Launched here rather than via systemd user units: this session isn't started
-- through uwsm, so graphical-session.target never activates.

hl.on("hyprland.start", function ()
    hl.exec_cmd("qs")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --watch cliphist store")

    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
end)
