import QtQuick
import Quickshell.Hyprland
import qs

// Workspaces 1–4 always shown, plus any others open on this monitor
Row {
    id: root

    required property var screen
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    readonly property var ids: {
        const s = new Set([1, 2, 3, 4]);
        for (const ws of Hyprland.workspaces.values) {
            if (ws.id > 0 && ws.monitor === monitor)
                s.add(ws.id);
        }
        return [...s].sort((a, b) => a - b);
    }

    function focus(target) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${target}" })`);
    }

    spacing: 2

    Repeater {
        model: root.ids

        delegate: Rectangle {
            id: button

            required property int modelData
            readonly property HyprlandWorkspace ws: Hyprland.workspaces.values.find(w => w.id === modelData) ?? null
            readonly property bool active: root.monitor?.activeWorkspace?.id === modelData
            // Gradient only on the focused monitor; other monitors get a faint highlight
            readonly property bool focused: active && (root.monitor?.focused ?? false)

            implicitWidth: label.implicitWidth + 16
            implicitHeight: Theme.barHeight - 8
            radius: 6
            color: active ? Theme.alpha(Theme.peach, 0.25)
                 : mouse.containsMouse ? Theme.alpha(Theme.peach, 0.12)
                 : "transparent"
            gradient: focused ? activeGradient : null

            Gradient {
                id: activeGradient
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: Theme.peach }
                GradientStop { position: 1; color: Theme.red }
            }

            BarText {
                id: label
                anchors.centerIn: parent
                text: button.modelData
                color: button.focused ? Theme.crust
                     : button.active ? Theme.fg
                     : button.ws?.urgent ? Theme.crit
                     : mouse.containsMouse ? Theme.fg
                     : Theme.muted
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.focus(button.modelData)
            }
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        property int acc: 0
        onWheel: e => {
            acc += e.angleDelta.y;
            if (Math.abs(acc) >= 120) {
                root.focus(acc > 0 ? "e-1" : "e+1");
                acc = 0;
            }
        }
    }
}
