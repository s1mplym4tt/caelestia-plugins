pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

Item {
    id: root

    readonly property string notePath: Paths.data + "/quick-note.txt"
    property bool loading: false

    Component.onCompleted: {
        Plugins.registerBarWidget("quick-note", barWidget, "right");
    }

    // ---- notes window --------------------------------------------------------
    FloatingWindow {
        id: noteWindow

        visible: false
        implicitWidth: 380
        implicitHeight: 300
        minimumSize.width: 260
        minimumSize.height: 160
        color: Colours.tPalette.m3surfaceContainerHigh
        title: qsTr("Quick Note")

        Item {
            anchors.fill: parent
            anchors.margins: Tokens.padding.medium

            ColumnLayout {
                anchors.fill: parent
                spacing: Tokens.spacing.small

                RowLayout {
                    Layout.fillWidth: true

                    StyledText {
                        Layout.fillWidth: true
                        text: qsTr("Quick Note")
                        font: Tokens.font.title.small
                    }

                    MaterialIcon {
                        text: "close"
                        color: Colours.palette.m3onSurfaceVariant
                        fontStyle: Tokens.font.icon.medium

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: noteWindow.visible = false
                        }
                    }
                }

                TextEdit {
                    id: noteEdit

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Colours.palette.m3onSurface
                    font: Tokens.font.body.medium
                    wrapMode: TextEdit.Wrap
                    selectByMouse: true
                    onTextChanged: {
                        if (!root.loading)
                            saveTimer.restart();
                    }
                }
            }
        }
    }

    // ---- persistence ---------------------------------------------------------
    Process {
        id: readProc

        running: true
        command: ["sh", "-c", "cat \"" + root.notePath + "\" 2>/dev/null || true"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.loading = true;
                noteEdit.text = text;
                root.loading = false;
            }
        }
    }

    Timer {
        id: saveTimer

        interval: 400
        repeat: false
        onTriggered: writeProc.running = true
    }

    Process {
        id: writeProc

        running: false
        command: [
            "python3",
            "-c",
            "import sys, os; p=sys.argv[1]; d=os.path.dirname(p); os.makedirs(d, exist_ok=True) if d else None; open(p, 'w').write(sys.argv[2])",
            root.notePath,
            noteEdit.text
        ]
    }

    // ---- bar widget ----------------------------------------------------------
    Component {
        id: barWidget

        Item {
            id: w

            implicitWidth: icon.implicitHeight + Tokens.padding.small
            implicitHeight: icon.implicitHeight

            StateLayer {
                anchors.fill: parent
                radius: Tokens.rounding.full
                onClicked: {
                    noteWindow.visible = !noteWindow.visible;
                    if (noteWindow.visible)
                        noteEdit.forceActiveFocus();
                }
            }

            MaterialIcon {
                id: icon

                anchors.centerIn: parent
                text: "sticky_note_2"
                color: Colours.palette.m3onSurfaceVariant
                fontStyle: Tokens.font.icon.builders.small.weight(Font.Bold).build()
            }
        }
    }
}
