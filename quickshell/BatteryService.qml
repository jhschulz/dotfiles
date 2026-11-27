pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    readonly property var devices: UPower.devices
    readonly property var battery: devices.values.filter(d => d.isLaptopBattery)[0]
    readonly property double percentage: battery.percentage
    readonly property bool hasBattery: battery != undefined
    readonly property bool isCharging: battery.state == UPowerDeviceState.Charging
}
