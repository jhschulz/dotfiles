pragma ComponentBehavior: Bound
import QtQuick

Rectangle {
    id: root
    property bool expanded: false
    signal clicked()
    implicitWidth: 180
    implicitHeight: Theme.pillHeight
    radius: height / 2
    color: mouse.containsMouse || expanded ? Theme.blue : Theme.background
    Accessible.role: Accessible.Button
    Accessible.name: "Audio controls"
    Accessible.onPressAction: root.clicked()
    activeFocusOnTab: true
    Keys.onSpacePressed: root.clicked()
    Keys.onReturnPressed: root.clicked()
    border.width: activeFocus ? 1 : 0
    border.color: Theme.gold

    Row {
        anchors.centerIn: parent
        height: 22
        spacing: 3
        Repeater {
            model: 24
            Rectangle {
                required property int index
                width: 3
                height: 2 + (AudioService.sink && AudioService.sink.audio
                    && !AudioService.sink.audio.muted ? (AudioService.levels[index] || 0) * 20 : 0)
                anchors.verticalCenter: parent.verticalCenter
                radius: 1.5
                color: Theme.gold
                Behavior on height { NumberAnimation { duration: 33 } }
            }
        }
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
