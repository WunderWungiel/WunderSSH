import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: "Settings"
            }

            Button {
                id: saveButton
                text: "Save"
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }
}
