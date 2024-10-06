import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    SilicaListView {

        anchors {
            top: parent.top
            bottom: coverActionArea.top
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }
        model: ["Omen", "Pi"]
        delegate: ListItem {

            anchors.topMargin: Theme.paddingSmall

            Row {

                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    text: modelData
                    width: parent.width - parent.spacing
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }
        }
    }
}
//    SilicaListView {

//        clip: true

//        anchors {
//            top: parent.top; bottom: coverActionArea.top
//            left: parent.left; right: parent.right
//            margins: Theme.paddingMedium
//        }

//        VerticalScrollDecorator { id: scrollBar; flickable: view }

//        header: Label {
//            text: "SSH Servers:"
//            font.pixelSize: Theme.fontSizeSmall
//        }

//        model: mainPage.serversModel
////        x: Theme.horizontalPageMargin

//        delegate: ListItem {

//            id: item

////            anchors.topMargin: Theme.paddingSmall
//            height: Theme.itemSizeSmall

//            Row {

//                width: parent.width

//                Label {
//                    id: itemLabel
//                    text: model.title
//                    font.pixelSize: Theme.fontSizeExtraSmall
//                }

//                Rectangle {
//                    id: itemSpaceRectangle
//                    opacity: 0

//                    Component.onCompleted: {
//                        var temp_width = parent.width - (Theme.paddingMedium * 2) - Theme.itemSizeExtraLarge - itemLabel.width;
//                        width = temp_width > 0 ? temp_width : 0;

//                    }
//                }

//                Rectangle {
//                    color: model.color
//                    width: Theme.itemSizeLarge
//                    height: Theme.itemSizeSmall / 4
//                    anchors.verticalCenter: parent.verticalCenter
//                    visible: itemSpaceRectangle.width !== 0
//                    radius: 5
//                }

//            }

//        }

//        CoverActionList {
//            id: coverAction
//            CoverAction {
//                iconSource: "image://theme/icon-cover-refresh"
//            }
//        }

//    Label {
//        id: label
//        anchors.centerIn: parent
//        text: qsTr("My Cover")
//    }

//    CoverActionList {
//        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-next"
//        }

//        CoverAction {
//            iconSource: "image://theme/icon-cover-pause"
//        }
//    }
