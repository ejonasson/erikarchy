import QtQuick
import Quickshell
import Quickshell.Networking
import qs

Module {
    id: root

    // Prefer a wired connection when both are up
    readonly property NetworkDevice device: {
        const up = Networking.devices.values.filter(d => d.connected);
        return up.find(d => d.type === DeviceType.Wired) ?? up[0] ?? null;
    }
    readonly property bool wifi: device?.type === DeviceType.Wifi
    readonly property WifiNetwork network: wifi ? device.networks.values.find(n => n.connected) ?? null : null
    readonly property int strength: Math.round((network?.signalStrength ?? 0) * 100)

    readonly property var wifiIcons: ["󰤟", "󰤢", "󰤥", "󰤨"]

    tooltip: !device ? "Disconnected"
           : wifi ? `${network?.name ?? "Wi-Fi"} (${strength}%)\n${device.name}`
           : device.name
    onClicked: Quickshell.execDetached(["nm-connection-editor"])

    BarText {
        text: !root.device ? "󰤮"
            : !root.wifi ? "󰈀"
            : root.wifiIcons[Math.min(3, Math.floor(root.strength / 25))]
        color: root.device ? Theme.fg : Theme.muted
    }
}
