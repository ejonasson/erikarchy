// Status bar replacing waybar. Reload happens automatically on save;
// run `qs` to start it, `qs log` to see errors.
import QtQuick
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
