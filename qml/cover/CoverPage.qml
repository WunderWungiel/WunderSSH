import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    SilicaListView {

        visible: mainPage.serversModel.count > 0

        anchors {
            top: parent.top
            bottom: coverActionArea.top
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }

        model: mainPage.serversModel

        header: Label {
            text: qsTr("Servers:")
            font.pixelSize: Theme.fontSizeLarge
        }

        Item {
            height: Theme.paddingLarge
        }

        delegate: ListItem {

            anchors.topMargin: Theme.paddingSmall

            Row {

                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    text: model.title
                    width: parent.width - parent.spacing
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
        }
    }

    Column {

        visible: mainPage.serversModel.count === 0

        anchors {
            top: parent.top
            bottom: coverActionArea.top
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }

        Label {
            text: "WunderSSH"
            color: Theme.highlightColor
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            x: Theme.horizontalPageMargin
            text: qsTr("No servers yet...")
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                addPage.reset();
                applicationWindow.pageStack.push(addPage);
                applicationWindow.activate();
            }
        }
    }
}
