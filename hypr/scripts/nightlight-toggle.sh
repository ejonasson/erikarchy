#!/bin/sh
# Toggle hyprsunset on/off. When re-enabled it applies the profile for the current time.
if pgrep -x hyprsunset >/dev/null; then
    pkill -x hyprsunset
    notify-send -t 1500 'Night light' 'Off'
else
    setsid -f hyprsunset >/dev/null 2>&1
    notify-send -t 1500 'Night light' 'On (scheduled)'
fi
