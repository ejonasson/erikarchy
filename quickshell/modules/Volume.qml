import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs

// Click opens pavucontrol, right click mutes, scroll changes volume by 5% (capped at 100%)
Module {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)

    tooltip: sink?.description ?? ""
    onClicked: button => {
        if (button === Qt.RightButton) {
            if (sink?.audio)
                sink.audio.muted = !sink.audio.muted;
        } else {
            Quickshell.execDetached(["pavucontrol"]);
        }
    }
    onScrolled: step => {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + step * 0.05));
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    BarText {
        text: root.muted ? "󰝟 muted"
            : `${["󰕿", "󰖀", "󰕾"][Math.min(2, Math.floor(root.volume / 34))]} ${root.volume}%`
        color: root.muted ? Theme.muted : Theme.fg
    }
}
