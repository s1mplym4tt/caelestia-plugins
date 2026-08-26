pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.utils
import qs.modules.nexus.common

Item {
    id: root

    Component.onCompleted: {
        Plugins.registerBarWidget("weather-chip", barWidget, "right");
        Plugins.registerPage({
            label: qsTr("Weather Chip"),
            icon: "partly_cloudy_day",
            description: qsTr("Taskbar weather widget"),
            category: "plugins",
            settings: [
                { label: qsTr("Widget"), keywords: ["weather", "chip", "temperature", "forecast"] },
                { label: qsTr("Location"), keywords: ["weather", "city", "location"] }
            ]
        }, pageComponent);
    }

    Component {
        id: barWidget

        Item {
            id: w

            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight

            StateLayer {
                anchors.fill: parent
                radius: Tokens.rounding.full
                onClicked: Weather.reload()
            }

            Row {
                id: row

                anchors.verticalCenter: parent.verticalCenter
                spacing: Tokens.spacing.small

                MaterialIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Weather.icon
                    color: Colours.palette.m3onSurfaceVariant
                    fontStyle: Tokens.font.icon.builders.small.weight(Font.Bold).build()
                }

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Weather.temp
                    font: Tokens.font.body.small
                }
            }
        }
    }

    Component {
        id: pageComponent

        PageBase {
            title: qsTr("Weather Chip")

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                width: parent.cappedWidth
                spacing: Tokens.spacing.extraSmall / 2

                SectionHeader {
                    first: true
                    text: qsTr("Weather Chip")
                }

                ConnectedRect {
                    Layout.fillWidth: true
                    first: true
                    last: true
                    implicitHeight: text.implicitHeight + Tokens.padding.largeIncreased * 2

                    StyledText {
                        id: text

                        anchors.fill: parent
                        anchors.margins: Tokens.padding.largeIncreased
                        text: qsTr("Shows the current weather in the taskbar. Click it to refresh.\n\nSet your location under Caelestia Settings → Language & Region → Weather Location.")
                        wrapMode: Text.Wrap
                        color: Colours.palette.m3onSurfaceVariant
                        font: Tokens.font.body.medium
                    }
                }
            }
        }
    }
}
