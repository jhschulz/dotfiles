import QtQuick
import Quickshell.Hyprland

Text {
    required property var monitor
    // Bindings update automatically when compositor focus or the title changes.
    text: monitor && monitor.focused && Hyprland.activeToplevel
        ? Hyprland.activeToplevel.title : ""
    textFormat: Text.PlainText
    elide: Text.ElideRight
    horizontalAlignment: Text.AlignHCenter
    color: Theme.secondary
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
}
