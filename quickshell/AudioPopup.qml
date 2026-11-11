pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PopupWindow {
    id: root
    required property var panelWindow
    readonly property var players: Mpris.players
    // PopupAnchor is opaque in the installed window module's static metadata.
    // qmllint disable missing-property unresolved-type unqualified
    anchor.window: panelWindow
    anchor.rect.x: Math.max(0, (panelWindow.width - width) / 2)
    anchor.rect.y: panelWindow.height
    // qmllint enable missing-property unresolved-type unqualified
    implicitWidth: Math.min(440, panelWindow.width)
    implicitHeight: Math.min(600, panelWindow.screen.height - panelWindow.height - Theme.padding)
    color: "transparent"
    grabFocus: true
    visible: false

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

            ScrollView {
                anchors.fill: parent
                clip: true
                contentWidth: availableWidth
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                palette.highlight: Theme.gold
                palette.button: Theme.background
                palette.text: Theme.foreground
                palette.windowText: Theme.foreground
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: parent.width
                    spacing: 16
                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            Layout.fillWidth: true
                            text: "Audio"
                            font.pixelSize: 20
                            color: Theme.foreground
                        }
                        AudioButton {
                            text: "×"
                            Accessible.name: "Close audio controls"
                            onClicked: root.visible = false
                        }
                    }
                    Label {
                        visible: !Pipewire.ready
                        text: "Connecting to PipeWire…"
                        color: Theme.secondary
                    }
                    AudioDeviceSection { output: true; Layout.fillWidth: true }
                    AudioDeviceSection { output: false; Layout.fillWidth: true }
                    Label { text: "Players"; color: Theme.gold; font.bold: true }
                    Label {
                        visible: root.players.values.length === 0
                        text: "No media players detected"
                        color: Theme.secondary
                    }
                    Repeater {
                        model: Mpris.players
                        delegate: ColumnLayout {
                            id: player
                            required property MprisPlayer modelData
                            Layout.fillWidth: true
                            spacing: 4
                            Label {
                                Layout.fillWidth: true
                                text: player.modelData.identity
                                textFormat: Text.PlainText
                                elide: Text.ElideRight
                                color: Theme.secondary
                            }
                            Label {
                                Layout.fillWidth: true
                                text: player.modelData.trackTitle || "No track information"
                                textFormat: Text.PlainText
                                elide: Text.ElideRight
                                color: Theme.foreground
                            }
                            Label {
                                Layout.fillWidth: true
                                text: player.modelData.trackArtist
                                visible: text.length > 0
                                textFormat: Text.PlainText
                                elide: Text.ElideRight
                                color: Theme.secondary
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 12
                                AudioButton {
                                    text: "\uf048"
                                    Accessible.name: "Previous track"
                                    ToolTip.visible: hovered
                                    ToolTip.text: "Previous track"
                                    enabled: player.modelData.canControl && player.modelData.canGoPrevious
                                    onClicked: player.modelData.previous()
                                }
                                AudioButton {
                                    text: player.modelData.isPlaying ? "\uf04c" : "\uf04b"
                                    Accessible.name: player.modelData.isPlaying ? "Pause" : "Play"
                                    ToolTip.visible: hovered
                                    ToolTip.text: player.modelData.isPlaying ? "Pause" : "Play"
                                    enabled: player.modelData.canControl && (player.modelData.isPlaying
                                        ? player.modelData.canPause : player.modelData.canPlay)
                                    onClicked: {
                                        if (player.modelData.isPlaying) player.modelData.pause();
                                        else player.modelData.play();
                                    }
                                }
                                AudioButton {
                                    text: "\uf051"
                                    Accessible.name: "Next track"
                                    ToolTip.visible: hovered
                                    ToolTip.text: "Next track"
                                    enabled: player.modelData.canControl && player.modelData.canGoNext
                                    onClicked: player.modelData.next()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
