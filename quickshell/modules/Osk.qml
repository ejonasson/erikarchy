import QtQuick
import Quickshell
import qs

// On-screen keyboard toggle; only visible in tablet mode (see hypr/scripts/tablet-mode.sh)
Module {
    visible: Globals.oskText !== ""
    tooltip: Globals.oskShown ? "Hide keyboard" : "Show keyboard"
    onClicked: Quickshell.execDetached([Globals.tabletScript, "toggle"])

    BarText {
        text: Globals.oskText
        font.pixelSize: 16
        color: Globals.oskShown ? Theme.peach : Theme.fg
    }
}
