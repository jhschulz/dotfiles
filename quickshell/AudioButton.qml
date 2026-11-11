import QtQuick
import QtQuick.Controls

Button {
    id: root
    implicitWidth: Math.max(32, implicitContentWidth + Theme.padding * 2)
    implicitHeight: 32
    padding: 6
    hoverEnabled: true
    opacity: enabled ? 1 : 0.4
    contentItem: Text {
        text: root.text
        textFormat: Text.PlainText
        elide: Text.ElideRight
        color: root.highlighted ? Theme.gold : Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        radius: height / 2
        color: root.hovered || root.down ? Theme.blue : "transparent"
        border.width: root.visualFocus || root.highlighted ? 1 : 0
        border.color: Theme.gold
    }
}
