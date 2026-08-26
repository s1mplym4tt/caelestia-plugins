pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    Component.onCompleted: {
        Plugins.registerBarWidget("pomodoro", barWidget, "right");
    }

    Component {
        id: barWidget

        Item {
            id: w

            readonly property int focusSeconds: 25 * 60
            property int remaining: focusSeconds
            property bool running: false

            implicitWidth: label.implicitWidth + Tokens.padding.small
            implicitHeight: label.implicitHeight

            function fmt(s: int): string {
                return `${String(Math.floor(s / 60)).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;
            }

            Timer {
                interval: 1000
                repeat: true
                running: w.running
                onTriggered: {
                    if (w.remaining > 0) {
                        w.remaining--;
                    } else {
                        w.running = false;
                        w.remaining = w.focusSeconds;
                    }
                }
            }

            StateLayer {
                anchors.fill: parent
                radius: Tokens.rounding.full
                onClicked: {
                    w.running = !w.running;
                    if (w.running && w.remaining === 0)
                        w.remaining = w.focusSeconds;
                }
            }

            MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text: "timer"
                color: w.running ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                fontStyle: Tokens.font.icon.small
            }

            StyledText {
                id: label

                anchors.left: parent.left
                anchors.leftMargin: Tokens.font.icon.small.pointSize + Tokens.spacing.small
                anchors.verticalCenter: parent.verticalCenter
                text: w.fmt(w.remaining)
                color: w.running ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                font: Tokens.font.label.small
            }
        }
    }
}
