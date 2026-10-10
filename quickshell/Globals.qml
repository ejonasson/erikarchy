pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// State shared by the bars on every monitor
Singleton {
    id: root

    property bool idleInhibited: false

    // On-screen keyboard button; text is empty in laptop mode so the button hides
    property string oskText: ""
    property bool oskShown: false

    readonly property string tabletScript: Quickshell.env("HOME") + "/.config/hypr/scripts/tablet-mode.sh"

    function refreshOsk() {
        oskStatus.running = true;
    }

    Process {
        id: oskStatus
        command: [root.tabletScript, "status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const s = JSON.parse(text);
                    root.oskText = s.text ?? "";
                    root.oskShown = s["class"] === "shown";
                } catch (e) {
                    root.oskText = "";
                }
            }
        }
    }

    // tablet-mode.sh calls `qs ipc call osk refresh` whenever the keyboard changes;
    // the slow timer only catches wvkbd being killed some other way.
    IpcHandler {
        target: "osk"
        function refresh(): void {
            root.refreshOsk();
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.refreshOsk()
    }
}
