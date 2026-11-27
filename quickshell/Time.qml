pragma Singleton
import Quickshell
import QtQuick

Singleton {
    // All panel instances share this clock rather than creating their own timers.
    readonly property string time: Qt.formatDateTime(clock.date, "ddd, MMM d · hh:mm A")
    readonly property string seconds: clock.seconds
    SystemClock {
        id: clock
    }
}
