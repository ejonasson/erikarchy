---------------------
---- KEYBINDINGS ----
---------------------

local programs    = require("programs")
local terminal    = programs.terminal
local fileManager = programs.fileManager
local menu        = programs.menu
local browser     = programs.browser

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Keep workspaces 1-4 around even when empty
for i = 1, 4 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Screenshots: saved to ~/Pictures/Screenshots and copied to the clipboard
local shotFile = "~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png"
local shotDone = "| wl-copy && notify-send -t 2000 'Screenshot' 'Saved and copied'"
hl.bind("Print",         hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && g=$(slurp) && grim -g \"$g\" - | tee " .. shotFile .. " " .. shotDone))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && grim - | tee " .. shotFile .. " " .. shotDone))

-- Clipboard history (cliphist)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p clipboard | cliphist decode | wl-copy"))

-- Firefox: Ctrl+1-8 jumps to that tab, Ctrl+9 to the last tab (Firefox on Linux only knows Alt+N).
-- Other apps still get the plain Ctrl+N.
for i = 1, 9 do
    hl.bind("CTRL + " .. i, function ()
        local w = hl.get_active_window()
        local mods = (w and w.class == "firefox") and "ALT" or "CTRL"
        hl.dispatch(hl.dsp.send_shortcut({ mods = mods, key = tostring(i) }))
    end)
end

-- Tablet mode: show the on-screen keyboard when the hinge flips back, hide it in laptop mode
hl.bind("switch:on:Intel HID switches",  hl.dsp.exec_cmd("~/.config/hypr/scripts/tablet-mode.sh on"),  { locked = true })
hl.bind("switch:off:Intel HID switches", hl.dsp.exec_cmd("~/.config/hypr/scripts/tablet-mode.sh off"), { locked = true })
