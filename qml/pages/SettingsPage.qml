import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page

    property string version: "0.3-1"

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Settings")
            }

            Button {
                id: saveButton
                text: qsTr("Save")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.pop()
            }

        }
    }
}
