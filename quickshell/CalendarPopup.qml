pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PopupWindow {
    id: root
    required property var panelWindow
    // The window module's metadata exposes PopupAnchor as an opaque type.
    // These properties are provided by Quickshell at runtime.
    // qmllint disable missing-property unresolved-type unqualified
    anchor.window: panelWindow
    anchor.rect.x: Math.max(0, panelWindow.width - width - Theme.padding)
    anchor.rect.y: panelWindow.height
    // qmllint enable missing-property unresolved-type unqualified
    implicitWidth: 320
    implicitHeight: 350
    color: "transparent"
    // Let the popup manage its own input grab and outside-click dismissal.
    grabFocus: true
    visible: false

    function toggle(): void {
        if (!visible) calendar.reset();
        visible = !visible;
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: 16
        border.color: Theme.gold
        border.width: 1

        FocusScope {
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: root.visible = false

            ColumnLayout {
                id: calendar
                anchors.fill: parent
                anchors.margins: Theme.padding
                spacing: 8
                property date displayedMonth: new Date()

                function reset(): void { displayedMonth = new Date(); }
                function moveMonth(offset: int): void {
                    displayedMonth = new Date(displayedMonth.getFullYear(),
                                              displayedMonth.getMonth() + offset, 1);
                }

                RowLayout {
                    Layout.fillWidth: true
                    CalendarButton {
                        text: "‹"
                        Accessible.name: "Previous month"
                        onClicked: calendar.moveMonth(-1)
                    }
                    Text {
                        Layout.fillWidth: true
                        text: grid.title
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                    CalendarButton {
                        text: "›"
                        Accessible.name: "Next month"
                        onClicked: calendar.moveMonth(1)
                    }
                }

                DayOfWeekRow {
                    Layout.fillWidth: true
                    locale: grid.locale
                    delegate: Text {
                        required property string shortName
                        text: shortName
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.secondary
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }

                MonthGrid {
                    id: grid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    month: calendar.displayedMonth.getMonth()
                    year: calendar.displayedMonth.getFullYear()
                    locale: Qt.locale()
                    delegate: Rectangle {
                        id: dayCell
                        required property var model
                        implicitWidth: 36
                        implicitHeight: 32
                        radius: height / 2
                        color: model.today ? Theme.gold : "transparent"
                        opacity: model.month === grid.month ? 1 : 0.35

                        Text {
                            anchors.centerIn: parent
                            text: dayCell.model.day
                            color: dayCell.model.today ? Theme.background : Theme.foreground
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                        }
                    }
                }

                CalendarButton {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Today"
                    onClicked: calendar.reset()
                }
            }
        }
    }

    component CalendarButton: Button {
        id: button
        implicitWidth: Math.max(32, implicitContentWidth + Theme.padding * 2)
        implicitHeight: 32
        padding: 6
        hoverEnabled: true
        contentItem: Text {
            text: button.text
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: height / 2
            color: button.hovered || button.down ? Theme.blue : "transparent"
            border.width: button.visualFocus ? 1 : 0
            border.color: Theme.gold
        }
    }
}
