import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Scope {
    // Variants creates one panel for each screen, including newly attached screens.
    Variants {
        model: Quickshell.screens

        // Quickshell creates the platform backend at runtime; its static metadata
        // marks the PanelWindow interface as uncreatable.
        // qmllint disable uncreatable-type
        PanelWindow {
            // qmllint enable uncreatable-type
            id: panel
            required property var modelData
            readonly property var monitor: Hyprland.monitorFor(screen)
            screen: modelData
            color: "transparent"
            implicitHeight: Theme.panelHeight
            exclusiveZone: Theme.panelHeight
            anchors { top: true; left: true; right: true }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.padding
                anchors.rightMargin: Theme.padding
                spacing: Theme.padding

                Workspaces { monitor: panel.monitor }
                Item {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.centerIn: parent
                        width: Math.min(parent.width, title.implicitWidth + Theme.padding * 2)
                        height: Theme.pillHeight
                        radius: height / 2
                        color: Theme.background
                        visible: title.text.length > 0 && width > 0

                        WindowTitle {
                            id: title
                            monitor: panel.monitor
                            anchors.fill: parent
                            anchors.leftMargin: Theme.padding
                            anchors.rightMargin: Theme.padding
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Rectangle {
                    implicitWidth: clock.implicitWidth + Theme.padding * 2
                    implicitHeight: Theme.pillHeight
                    radius: height / 2
                    color: clockMouse.containsMouse || calendarPopup.visible
                        ? Theme.blue : Theme.background

                    ClockWidget {
                        id: clock
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: clockMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: calendarPopup.toggle()
                    }
                }
            }

            CalendarPopup {
                id: calendarPopup
                panelWindow: panel
            }
        }
    }
}
