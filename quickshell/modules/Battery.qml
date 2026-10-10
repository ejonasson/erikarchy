import QtQuick
import Quickshell.Services.UPower
import qs

Module {
    id: root

    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property int percent: Math.round((battery?.percentage ?? 0) * 100)
    readonly property bool charging: battery?.state === UPowerDeviceState.Charging
    readonly property bool plugged: !charging && !UPower.onBattery

    readonly property var icons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    function duration(seconds) {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor(seconds % 3600 / 60);
        return h > 0 ? `${h} h ${m} min` : `${m} min`;
    }

    visible: battery?.isLaptopBattery ?? false
    tooltip: {
        const t = charging ? battery.timeToFull : battery?.timeToEmpty ?? 0;
        const timeLine = t > 0 ? `${duration(t)} ${charging ? "until full" : "remaining"}\n` : "";
        return `${timeLine}${Math.abs(battery?.changeRate ?? 0).toFixed(1)} W`;
    }

    BarText {
        text: `${root.charging ? "󰂄" : root.plugged ? "󰚥" : root.icons[Math.min(9, Math.floor(root.percent / 10))]} ${root.percent}%`
        color: root.charging || root.plugged ? Theme.green
             : root.percent <= 10 ? Theme.crit
             : root.percent <= 25 ? Theme.warn
             : Theme.fg
    }
}
