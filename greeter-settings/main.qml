pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services
import qs.modules.nexus.common

Item {
    id: root

    Component.onCompleted: {
        Plugins.registerPage({
            label: qsTr("Greeter & Lock Screen"),
            icon: "lock",
            description: qsTr("Lock screen and greeter customization"),
            category: "plugins",
            settings: [
                { label: qsTr("Lock screen"), keywords: ["greeter", "lock", "fingerprint", "notifications", "startup"] }
            ]
        }, pageComponent);
    }

    Component {
        id: pageComponent

        PageBase {
            title: qsTr("Greeter & Lock Screen")

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                width: parent.cappedWidth
                spacing: Tokens.spacing.extraSmall / 2

                SectionHeader {
                    first: true
                    text: qsTr("Lock screen")
                }

                ToggleRow {
                    first: true
                    Layout.fillWidth: true
                    text: qsTr("Hide notifications")
                    subtext: qsTr("Don't show notifications on the lock screen")
                    checked: GlobalConfig.lock.hideNotifs
                    onToggled: GlobalConfig.lock.hideNotifs = checked
                }

                ToggleRow {
                    Layout.fillWidth: true
                    text: qsTr("Fingerprint unlock")
                    subtext: qsTr("Allow unlocking with a fingerprint reader")
                    checked: GlobalConfig.lock.enableFprint
                    onToggled: GlobalConfig.lock.enableFprint = checked
                }

                StepperRow {
                    Layout.fillWidth: true
                    label: qsTr("Fingerprint attempts")
                    subtext: qsTr("Tries before falling back to the password")
                    value: GlobalConfig.lock.maxFprintTries
                    from: 1
                    to: 5
                    stepSize: 1
                    onMoved: v => GlobalConfig.lock.maxFprintTries = Math.round(v)
                }

                ToggleRow {
                    Layout.fillWidth: true
                    text: qsTr("Lock on startup")
                    subtext: qsTr("Lock the session right after logging in")
                    checked: GlobalConfig.lock.lockOnStartup
                    onToggled: GlobalConfig.lock.lockOnStartup = checked
                }

                ToggleRow {
                    last: true
                    Layout.fillWidth: true
                    text: qsTr("Recolour logo")
                    subtext: qsTr("Tint the lock screen logo with the accent colour")
                    checked: GlobalConfig.lock.recolourLogo
                    onToggled: GlobalConfig.lock.recolourLogo = checked
                }
            }
        }
    }
}
