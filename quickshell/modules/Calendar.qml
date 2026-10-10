import QtQuick
import qs

// Month grid, weeks starting Monday, today highlighted
Column {
    id: root

    required property date date

    readonly property int year: date.getFullYear()
    readonly property int month: date.getMonth()
    readonly property int today: date.getDate()
    // Blank cells before the 1st (Monday = 0)
    readonly property int lead: (new Date(year, month, 1).getDay() + 6) % 7
    readonly property int days: new Date(year, month + 1, 0).getDate()

    spacing: 4

    BarText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDate(root.date, "MMMM yyyy")
        font.bold: true
    }

    Grid {
        columns: 7
        columnSpacing: 4
        rowSpacing: 2

        Repeater {
            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
            BarText {
                required property string modelData
                width: 22
                horizontalAlignment: Text.AlignRight
                text: modelData
                color: Theme.muted
            }
        }

        Repeater {
            model: root.lead + root.days
            BarText {
                required property int index
                readonly property int day: index - root.lead + 1
                width: 22
                horizontalAlignment: Text.AlignRight
                text: day > 0 ? day : ""
                color: day === root.today ? Theme.peach : Theme.fg
                font.bold: day === root.today
            }
        }
    }
}
