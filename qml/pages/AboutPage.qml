import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width

            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("About")
            }

            Label {
                text: "WunderSSH"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Text {
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
                text: qsTr("SSH servers manager for Sailfish OS") + "\n" + qsTr("Version") + ": " + settingsPage.version + "\n\n" + qsTr("Made by Wunder Wungiel")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                text: qsTr("Donate")
                onClicked: Qt.openUrlExternally("https://paypal.me/wunderwungiel")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: qsTr("Source code")
                onClicked: Qt.openUrlExternally("https://github.com/WunderWungiel/WunderSSH")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: qsTr("My website")
                onClicked: Qt.openUrlExternally("http://wunderwungiel.pl")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
}
