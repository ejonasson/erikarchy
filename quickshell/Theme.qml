pragma Singleton

import QtQuick
import Quickshell

// Catppuccin Mocha — matches the Hyprland borders, hyprlock and the old waybar
Singleton {
    readonly property color bg: Qt.rgba(30 / 255, 30 / 255, 46 / 255, 0.85)  // base
    readonly property color crust: "#11111b"
    readonly property color fg: "#cdd6f4"       // text
    readonly property color muted: "#6c7086"    // overlay0
    readonly property color peach: "#fab387"
    readonly property color red: "#f38ba8"
    readonly property color green: "#a6e3a1"
    readonly property color warn: "#f9e2af"     // yellow
    readonly property color crit: red

    readonly property string font: "JetBrainsMono Nerd Font Propo"
    readonly property int fontSize: 13

    readonly property int barHeight: 30
    readonly property int modulePadding: 10

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
