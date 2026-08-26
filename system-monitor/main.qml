pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import Caelestia.Services
import qs.components
import qs.services

Item {
    id: root

    Component.onCompleted: {
        Plugins.registerBarWidget("system-monitor", barWidget, "right");
    }

    function pct(v: real): string {
        return isNaN(v) ? "--%" : `${Math.round(v * 100)}%`;
    }

    Component {
        id: barWidget

        Item {
            id: w

            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight

            Row {
                id: row

                anchors.verticalCenter: parent.verticalCenter
                spacing: Tokens.spacing.medium

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: `CPU ${root.pct(Cpu.percentage)}`
                    font: Tokens.font.label.small
                    color: Colours.palette.m3onSurfaceVariant
                }

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: `RAM ${root.pct(Memory.percentage)}`
                    font: Tokens.font.label.small
                    color: Colours.palette.m3onSurfaceVariant
                }
            }
        }
    }
}
