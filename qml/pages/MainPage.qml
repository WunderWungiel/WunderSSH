import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property alias serversModel:serversModel
    property alias listView:listView
    property alias busyIndicator:busyIndicator

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Medium
        running: true
        anchors.centerIn: parent
        visible: running
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: serversModel
        visible: false

        PullDownMenu {

            MenuItem {
                text: "About"
            }

            MenuItem {
                text: "Settings"
                onClicked: pageStack.animatorPush(settingsPage)
            }

            MenuItem {
                text: "Add server"
                onClicked: {
                    addPage.reset();
                    pageStack.animatorPush(addPage);
                }
            }
        }

        header: PageHeader { title: "WunderSSH" }

        delegate: ListItem {
            width: listView.width

            menu: ContextMenu {
                MenuItem {
                    text: "Connect"
                    onClicked: connectToServer(model.id)
                }
                MenuItem {
                    text: "Edit"
                    onClicked: {
                        editPage.init(model.id);
                        pageStack.animatorPush(editPage, {"id": model.id})
                    }
                }
                MenuItem {
                    text: "Delete"
                    onClicked: remorseDelete(function () {
                        removeServer(model.id);
                        serversModel.update();
                    })
                }
            }

            onClicked: connectToServer(model.id)

            Row {

                x: Theme.horizontalPageMargin
                spacing: Theme.paddingSmall

                Label {
                    id: itemLabel
                    text: model.title
                    color: model.color
                    wrapMode: Label.WrapAnywhere
                }

                Rectangle {
                    id: itemSpaceRectangle
                    color: "transparent"
                    height: Theme.itemSizeExtraSmall / 4

                    Component.onCompleted: {
                        var temp_width = page.width - (Theme.horizontalPageMargin * 2) - Theme.itemSizeExtraLarge - itemLabel.width;
                        width = temp_width > 0 ? temp_width : 0;
                    }
                }

                Rectangle {
                    color: model.color
                    width: Theme.itemSizeExtraLarge
                    height: Theme.itemSizeExtraSmall / 4
                    anchors.verticalCenter: parent.verticalCenter

                    visible: itemSpaceRectangle.width !== 0

                    radius: 5
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count == 0
            text: "No servers configured yet..."
            hintText: "Pull down to configure one!"
        }
    }

    ListModel {
        id: serversModel

        function update() {
            var result = getServers()

            serversModel.clear()

            for (var i = 0; i < result.rows.length; i++) {
                serversModel.append({
                    "id": result.rows.item(i).id,
                    "host": result.rows.item(i).title,
                    "username": result.rows.item(i).title,
                    "params": result.rows.item(i).title,
                    "title": result.rows.item(i).title,
                    "port": result.rows.item(i).port,
                    "auth_method": result.rows.item(i).auth_method,
                    "pubkey": result.rows.item(i).pubkey,
                    "password": result.rows.item(i).password,
                    "color": result.rows.item(i).color
                });
            }
        }
    }
}
