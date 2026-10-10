import QtQuick
import Quickshell
import Quickshell.Io
import qs

// Scroll changes brightness via brightnessctl. sysfs doesn't send change
// notifications, so the value is re-read once a second.
Module {
    id: root

    property string device: "intel_backlight"
    property int current: 0
    property int max: 1
    readonly property int percent: Math.round(current * 100 / max)

    onScrolled: step => {
        Quickshell.execDetached(["brightnessctl", "-e4", "-n2", "set", step > 0 ? "5%+" : "5%-"]);
    }

    FileView {
        id: brightness
        path: `/sys/class/backlight/${root.device}/brightness`
        onLoaded: root.current = parseInt(text())
    }

    FileView {
        path: `/sys/class/backlight/${root.device}/max_brightness`
        onLoaded: root.max = Math.max(1, parseInt(text()))
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: brightness.reload()
    }

    BarText {
        text: `${["󰃞", "󰃟", "󰃠"][Math.min(2, Math.floor(root.percent / 34))]} ${root.percent}%`
    }
}
