import QtQuick
import Quickshell.Hyprland

Row {
    id: root
    required property var monitor
    spacing: 4

    Repeater {
        model: Hyprland.workspaces

        // Keep every delegate bound to its workspace so monitor moves stay reactive.
        delegate: Rectangle {
            id: button
            required property var modelData
            readonly property bool belongsHere: root.monitor !== null
                && modelData.monitor === root.monitor
                && !modelData.name.startsWith("special:")
            visible: belongsHere
            width: visible ? Math.max(Theme.pillHeight, content.implicitWidth + Theme.padding * 2) : 0
            height: Theme.pillHeight
            radius: height / 2
            color: mouse.containsMouse ? Theme.blue : Theme.background
            border.width: modelData.active || modelData.urgent ? 1 : 0
            border.color: modelData.urgent ? Theme.red : Theme.gold

            // Reading the model and app IDs inside a binding keeps icons reactive.
            readonly property var icons: {
                const result = [];
                for (const window of modelData.toplevels.values) {
                    const appId = window.wayland?.appId || window.lastIpcObject.class || "";
                    const icon = AppIcons.forApp(appId);
                    if (!result.includes(icon)) result.push(icon);
                }
                return result;
            }

            Row {
                id: content
                anchors.centerIn: parent
                spacing: 6

                Text {
                    text: button.modelData.name
                    color: button.modelData.urgent ? Theme.red
                        : button.modelData.active ? Theme.gold : Theme.secondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
                Repeater {
                    model: button.icons
                    delegate: Text {
                        required property string modelData
                        text: modelData
                        color: Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }
            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: button.modelData.activate()
            }
        }
    }
}
