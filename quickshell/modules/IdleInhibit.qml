import QtQuick
import qs

// Click to stop hypridle from locking/dimming; the inhibitor itself lives in Bar.qml
Module {
    tooltip: Globals.idleInhibited ? "Idle inhibited (no auto-lock)" : "Idle allowed"
    onClicked: Globals.idleInhibited = !Globals.idleInhibited

    BarText {
        text: Globals.idleInhibited ? "󰅶" : "󰛊"
        color: Globals.idleInhibited ? Theme.peach : Theme.fg
    }
}
