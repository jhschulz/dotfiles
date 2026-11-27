import QtQuick

Rectangle {
    implicitWidth: batteryText.implicitWidth + Theme.padding * 2
    implicitHeight: Theme.pillHeight
    radius: height / 2
    color: Theme.background
    border.width: 1
    border.color: Theme.gold

    Text {
        id: batteryText
        anchors.centerIn: parent

        readonly property string batteryIcon: {
            if (BatteryService.isCharging) {
                return Time.seconds % 4 == 3 ? "\uf240"
                : Time.seconds % 4 == 2 ? "\uf241"
                : Time.seconds % 4 == 1 ? "\uf242"
                :"\uf243"
            }
            else {
                return BatteryService.percentage > 0.8 ? "\uf240"
                : BatteryService.percentage > 0.6 ? "\uf241"
                : BatteryService.percentage > 0.4 ? "\uf242"
                : BatteryService.percentage > 0.2 ? "\uf243"
                : "\uf244"
            }
        }

        text: "%1 %2%".arg(batteryIcon, String(BatteryService.percentage).substring(2,4))
        color: Theme.gold
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }
}
