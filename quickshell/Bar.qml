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

                Workspaces { id: workspaces; monitor: panel.monitor }
                Item {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    Layout.fillHeight: true
                }
                Rectangle {
                    id: clockPill
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
                        onClicked: {
                            audioPopup.visible = false;
                            calendarPopup.toggle();
                        }
                    }
                }
            }

            AudioVisualizer {
                anchors.centerIn: parent
                // Keep the visualizer centered on the screen and clear of side pills.
                width: Math.max(0, Math.min(implicitWidth, panel.width
                    - 2 * (Math.max(workspaces.width, clockPill.width) + Theme.padding * 2)))
                visible: width > 0
                clip: true
                expanded: audioPopup.visible
                onClicked: {
                    calendarPopup.visible = false;
                    audioPopup.visible = !audioPopup.visible;
                }
            }

            CalendarPopup {
                id: calendarPopup
                panelWindow: panel
            }
            AudioPopup {
                id: audioPopup
                panelWindow: panel
            }
        }
    }
}
