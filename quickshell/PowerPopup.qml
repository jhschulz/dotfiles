pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PopupWindow {
    id: root
    required property var panelWindow
    property string errorMessage: ""
    // PopupAnchor is opaque in the installed window module's static metadata.
    // qmllint disable missing-property unresolved-type unqualified
    anchor.window: panelWindow
    anchor.rect.x: Math.max(0, panelWindow.width - width - Theme.padding)
    anchor.rect.y: panelWindow.height
    // qmllint enable missing-property unresolved-type unqualified
    implicitWidth: Math.min(340, panelWindow.width)
    implicitHeight: content.implicitHeight + Theme.padding * 2
    color: "transparent"
    grabFocus: true
    visible: false
    onVisibleChanged: if (visible) errorMessage = ""

    function runAction(command: list<string>): void {
        if (action.running) return;
        errorMessage = "";
        action.command = command;
        action.running = true;
    }

    Process {
        id: action
        stderr: StdioCollector { id: actionError }
        stdout: StdioCollector { id: actionOutput }
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0 && exitStatus === 0) root.visible = false;
            else root.errorMessage = actionError.text.trim() || actionOutput.text.trim() || "The power action failed.";
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Theme.background
        border.color: Theme.gold
        border.width: 1

        FocusScope {
            anchors.fill: parent
            anchors.margins: Theme.padding
            focus: true
            Keys.onEscapePressed: root.visible = false

            ColumnLayout {
                id: content
                width: parent.width
                spacing: 12
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: "Power"
                        color: Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: 20
                    }
                    AudioButton {
                        text: "×"
                        Accessible.name: "Close power controls"
                        onClicked: root.visible = false
                    }
                }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 12
                    rowSpacing: 12
                    enabled: !action.running
                    AudioButton {
                        Layout.fillWidth: true
                        implicitHeight: 48
                        text: "\uf08b  Logout"
                        Accessible.name: "Log out"
                        onClicked: root.runAction(["hyprctl", "eval", "hl.dispatch(hl.dsp.exit())"])
                    }
                    AudioButton {
                        Layout.fillWidth: true
                        implicitHeight: 48
                        text: "\uf186  Sleep"
                        Accessible.name: "Sleep"
                        onClicked: root.runAction(["systemctl", "suspend"])
                    }
                    AudioButton {
                        Layout.fillWidth: true
                        implicitHeight: 48
                        text: "\uf2dc  Hibernate"
                        Accessible.name: "Hibernate"
                        onClicked: root.runAction(["systemctl", "hibernate"])
                    }
                    AudioButton {
                        Layout.fillWidth: true
                        implicitHeight: 48
                        text: "\uf011  Shutdown"
                        Accessible.name: "Shut down"
                        onClicked: root.runAction(["systemctl", "poweroff"])
                    }
                }
                Label {
                    Layout.fillWidth: true
                    visible: action.running
                    text: "Working…"
                    color: Theme.secondary
                    font.family: Theme.fontFamily
                }
                Label {
                    Layout.fillWidth: true
                    visible: root.errorMessage.length > 0
                    text: root.errorMessage
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                    color: Theme.red
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }
        }
    }
}
