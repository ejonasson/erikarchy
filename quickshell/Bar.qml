import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules

PanelWindow {
    id: bar

    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 8
        left: 20
        right: 20
    }
    implicitHeight: Theme.barHeight
    color: "transparent"
    WlrLayershell.namespace: "quickshell-bar"

    IdleInhibitor {
        window: bar
        enabled: Globals.idleInhibited
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        radius: 10
        border.width: 1
        border.color: Theme.alpha(Theme.peach, 0.25)

        Workspaces {
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            screen: bar.screen
        }

        Clock {
            anchors.centerIn: parent
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.verticalCenter: parent.verticalCenter

            Osk {}
            Tray {
                bar: bar
            }
            IdleInhibit {}
            Network {}
            Volume {}
            Backlight {}
            Battery {}
        }
    }
}
