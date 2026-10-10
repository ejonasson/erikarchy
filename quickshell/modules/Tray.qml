import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs

// Left click activates, middle click secondary-activates, right click opens the menu
Row {
    id: root

    required property var bar

    visible: SystemTray.items.values.length > 0
    leftPadding: Theme.modulePadding
    rightPadding: Theme.modulePadding
    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: entry

            required property SystemTrayItem modelData

            implicitWidth: 15
            implicitHeight: Theme.barHeight

            IconImage {
                anchors.centerIn: parent
                implicitSize: 15
                source: entry.modelData.icon
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: e => {
                    const item = entry.modelData;
                    if (e.button === Qt.MiddleButton) {
                        item.secondaryActivate();
                    } else if (e.button === Qt.LeftButton && !item.onlyMenu) {
                        item.activate();
                    } else if (item.hasMenu) {
                        const p = entry.mapToItem(null, 0, entry.height);
                        item.display(root.bar, p.x, p.y + 6);
                    }
                }
                onWheel: w => entry.modelData.scroll(w.angleDelta.y, false)
            }

            Tooltip {
                target: entry
                show: mouse.containsMouse
                text: entry.modelData.tooltipTitle || entry.modelData.title
            }
        }
    }
}
