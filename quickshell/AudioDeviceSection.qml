pragma ComponentBehavior: Bound
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property bool output
    readonly property var devices: output ? AudioService.outputs : AudioService.inputs
    readonly property var defaultNode: output ? Pipewire.defaultAudioSink : Pipewire.defaultAudioSource
    spacing: 8

    Label {
        text: root.output ? "Output" : "Input"
        color: Theme.gold
        font.bold: true
    }
    Label {
        visible: root.devices.length === 0
        text: root.output ? "No output devices available" : "No input devices available"
        color: Theme.secondary
    }
    Repeater {
        model: root.devices
        delegate: ColumnLayout {
            id: device
            required property PwNode modelData
            readonly property var audio: modelData.audio
            readonly property bool available: modelData.ready && audio !== null
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    text: device.modelData.description || device.modelData.nickname || device.modelData.name
                    textFormat: Text.PlainText
                    elide: Text.ElideRight
                    color: Theme.foreground
                    ToolTip.visible: deviceNameMouse.containsMouse
                    ToolTip.text: text
                    MouseArea {
                        id: deviceNameMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }
                }
                AudioButton {
                    text: highlighted ? "Default" : "Use"
                    highlighted: device.modelData === root.defaultNode
                    Accessible.name: "Use " + device.modelData.description + " as default"
                    onClicked: {
                        if (root.output) Pipewire.preferredDefaultAudioSink = device.modelData;
                        else Pipewire.preferredDefaultAudioSource = device.modelData;
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                AudioButton {
                    text: device.available && device.audio.muted ? "Unmute" : "Mute"
                    enabled: device.available
                    highlighted: device.available && device.audio.muted
                    onClicked: device.audio.muted = !device.audio.muted
                }
                Slider {
                    Layout.fillWidth: true
                    enabled: device.available
                    from: 0
                    to: 1
                    value: device.available ? device.audio.volume : 0
                    Accessible.name: root.output ? "Output volume" : "Input volume"
                    onMoved: if (device.available) device.audio.volume = value
                }
                Label {
                    Layout.preferredWidth: 52
                    horizontalAlignment: Text.AlignRight
                    text: device.available ? Math.round(device.audio.volume * 100) + "%" : "—"
                    color: Theme.secondary
                }
            }
        }
    }
}
