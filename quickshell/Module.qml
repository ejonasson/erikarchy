import QtQuick

// One bar entry: padded content, click/scroll handling and an optional tooltip
Item {
    id: root

    property string tooltip: ""
    default property alias content: row.data
    readonly property bool hovered: mouse.containsMouse

    signal clicked(int button)
    signal scrolled(int step)  // +1 up, -1 down

    implicitWidth: row.implicitWidth + Theme.modulePadding * 2
    implicitHeight: Theme.barHeight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: e => root.clicked(e.button)

        // Touchpads send many small deltas; emit one step per mouse-wheel notch
        property int acc: 0
        onWheel: w => {
            acc += w.angleDelta.y;
            while (Math.abs(acc) >= 120) {
                root.scrolled(acc > 0 ? 1 : -1);
                acc -= acc > 0 ? 120 : -120;
            }
        }
    }

    Tooltip {
        id: tip
        target: root
        show: root.hovered
        text: root.tooltip
    }
}
