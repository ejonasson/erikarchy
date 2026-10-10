#!/bin/sh
# Show/hide the on-screen keyboard (wvkbd) when the hinge flips to tablet mode.
# on|off:  called by the "switch:on/off:Intel HID switches" binds in binds.lua
# toggle:  show/hide the keyboard (quickshell bar button); only acts in tablet mode
# status:  JSON for the bar's keyboard button (~/.config/quickshell/modules/Osk.qml); empty in laptop mode so the button hides
#
# Don't start wvkbd with --auto: that makes it an input method, and Hyprland
# ignores shortcuts (e.g. Super+Q) typed on an input method's keyboard.

KBD=wvkbd-mobintl
# wvkbd can't report whether it's shown, so track it here
STATE="${XDG_RUNTIME_DIR:-/tmp}/osk-visible"

# Catppuccin Mocha: crust background, surface keys, peach/pink when pressed
start() {
    # 380px landscape / 500px portrait, about a third of the 1920x1200 screen
    setsid -f $KBD -L 380 -H 500 -R 6 --fn "JetBrainsMono Nerd Font 16" \
        --bg 11111b --fg 313244 --fg-sp 45475a \
        --press fab387 --press-sp f38ba8 \
        --swipe fab387 --swipe-sp f38ba8 \
        --text cdd6f4 --text-sp cdd6f4 \
        --text-press 11111b --text-press-sp 11111b \
        --text-swipe 11111b --text-swipe-sp 11111b \
        >/dev/null 2>&1
}

show() { pkill -USR2 -x $KBD; echo 1 > "$STATE"; }
hide() { pkill -USR1 -x $KBD; echo 0 > "$STATE"; }

refresh_bar() {
    qs ipc call osk refresh >/dev/null 2>&1 &
}

case "$1" in
    on)
        if pgrep -x $KBD >/dev/null; then show; else start; echo 1 > "$STATE"; fi
        refresh_bar
        ;;
    off)
        pkill -x $KBD
        rm -f "$STATE"
        refresh_bar
        ;;
    toggle)
        pgrep -x $KBD >/dev/null || exit 0
        if [ "$(cat "$STATE" 2>/dev/null)" = 1 ]; then hide; else show; fi
        refresh_bar
        ;;
    status)
        pgrep -x $KBD >/dev/null || { echo '{"text": ""}'; exit 0; }
        if [ "$(cat "$STATE" 2>/dev/null)" = 1 ]; then
            echo '{"text": "󰌌", "class": "shown", "tooltip": "Hide keyboard"}'
        else
            echo '{"text": "󰌐", "class": "hidden", "tooltip": "Show keyboard"}'
        fi
        ;;
esac
