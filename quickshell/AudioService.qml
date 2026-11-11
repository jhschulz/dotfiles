pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root
    // Keep the model dynamic: its installed metadata does not expose ObjectModel.values.
    readonly property var nodeModel: Pipewire.nodes
    readonly property var devices: nodeModel.values.filter(node => node.audio && !node.isStream)
    readonly property var outputs: devices.filter(node => node.isSink)
    readonly property var inputs: devices.filter(node => !node.isSink)
    property var levels: Array(24).fill(0)
    readonly property PwNode sink: Pipewire.defaultAudioSink

    function readSpectrum(frame: string): void {
        const fields = frame.trim().split(";");
        if (fields[fields.length - 1] === "") fields.pop();
        if (fields.length !== 24 || fields.some(value => !/^\d+$/.test(value))) return;
        levels = fields.map(value => Math.min(1, Number(value) / 1000));
        staleFrame.restart();
    }

    // Bind device parameters so volume/mute changes stay synchronized with PipeWire.
    PwObjectTracker { objects: root.devices }
    // One FFT process serves every screen, with bands ordered bass to treble.
    Process {
        id: cava
        command: ["cava", "-p", decodeURIComponent(Qt.resolvedUrl("cava.conf").toString().replace(/^file:\/\//, ""))]
        stdout: SplitParser { onRead: data => root.readSpectrum(data) }
        stderr: SplitParser { onRead: data => console.warn("CAVA:", data) }
        onRunningChanged: if (!running) root.levels = Array(24).fill(0)
    }

    Connections {
        target: Pipewire
        function onDefaultAudioSinkChanged(): void {
            cava.running = false;
            root.levels = Array(24).fill(0);
        }
    }

    // Recover after server/device changes or an unexpected CAVA exit.
    Timer {
        id: retry
        interval: 3000
        repeat: true
        running: root.sink !== null
        triggeredOnStart: true
        onTriggered: if (root.sink && !cava.running) cava.running = true
    }
    Timer {
        id: staleFrame
        interval: 1000
        onTriggered: root.levels = Array(24).fill(0)
    }
}
