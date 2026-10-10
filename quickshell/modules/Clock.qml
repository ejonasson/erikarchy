import QtQuick
import Quickshell
import qs

// HH:MM; click for the date, hover for a month calendar
Module {
    id: root

    property bool showDate: false

    onClicked: showDate = !showDate

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    BarText {
        text: Qt.formatDateTime(clock.date, root.showDate ? "ddd dd MMM  HH:mm" : "HH:mm")
        font.bold: true
        font.letterSpacing: 1
    }

    Tooltip {
        target: root
        show: root.hovered

        Calendar {
            date: clock.date
        }
    }
}
