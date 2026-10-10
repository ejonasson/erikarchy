import QtQuick
import Quickshell

// Hover popup below `target`; set `text`, or put items inside for custom content
PopupWindow {
    id: tip

    required property Item target
    property bool show: false
    property string text: ""
    default property alias content: box.data

    property bool shown: false

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 8

    visible: shown && (text !== "" || box.children.length > 1)
    color: "transparent"
    implicitWidth: frame.implicitWidth
    implicitHeight: frame.implicitHeight

    onShowChanged: {
        if (show) {
            delay.restart();
        } else {
            delay.stop();
            shown = false;
        }
    }

    Timer {
        id: delay
        interval: 400
        onTriggered: tip.shown = true
    }

    Rectangle {
        id: frame
        implicitWidth: box.implicitWidth + 20
        implicitHeight: box.implicitHeight + 14
        color: Theme.bg
        radius: 8
        border.width: 1
        border.color: Theme.alpha(Theme.peach, 0.4)

        Column {
            id: box
            anchors.centerIn: parent

            BarText {
                visible: tip.text !== ""
                text: tip.text
            }
        }
    }
}
