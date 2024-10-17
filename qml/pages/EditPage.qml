import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string id

    function init(id) {

        var result = getServer(id);

        if (result.rows.length === 0) {
            Notices.show(qsTr("Error: server doesn't exist..."), Notice.Short, Notice.Center);
            return;
        }

        var serverInfo = {
            "id": result.rows.item(0).id,
            "title": result.rows.item(0).title,
            "host": result.rows.item(0).host,
            "username": result.rows.item(0).username,
            "params": result.rows.item(0).params,
            "port": result.rows.item(0).port,
            "auth_method": result.rows.item(0).auth_method,
            "pubkey": result.rows.item(0).pubkey,
            "password": result.rows.item(0).password,
            "color": result.rows.item(0).color
        };

        pageHeader.title = qsTr("Edit") + ' \"' + serverInfo.title + '\"'
        titleField.text = serverInfo.title
        hostField.text = serverInfo.host
        usernameField.text = serverInfo.username
        paramsField.text = serverInfo.params
        portField.text = String(serverInfo.port)
        passwordField.text = (serverInfo.password !== null) ? serverInfo.password : ""
        colorIndicator.color = serverInfo.color

        if (serverInfo.auth_method === "auto") authMethodBox.currentIndex = 0;
        if (serverInfo.auth_method === "password") authMethodBox.currentIndex = 1;

        titleField.text = serverInfo.title

    }

    SilicaFlickable {        
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Connect")
                onClicked: connectToServer(page.id)
            }
        }

        Column {
            id: column
            width: page.width

            spacing: Theme.paddingSmall

            PageHeader {
                id: pageHeader
            }

            TextField {
                id: titleField
                label: qsTr("Title")
                acceptableInput: text.length > 0

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: hostField.focus = true
            }

            TextField {
                id: hostField
                label: qsTr("Host")
                acceptableInput: text.length > 0

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: usernameField.focus = true
            }

            TextField {
                id: usernameField
                label: qsTr("Username")
                acceptableInput: text.length > 0

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: paramsField.focus = true
            }

            TextArea {
                id: paramsField
                label: qsTr("Params")
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: portField.focus = true
            }

            TextField {
                id: portField
                property var pattern: new RegExp(/^\d+$/)

                text: "22"
                label: qsTr("Port")
                acceptableInput: pattern.test(text)
                inputMethodHints: Qt.ImhDigitsOnly
            }

            ComboBox {

                id: authMethodBox
                label: qsTr("Authentication method")
                width: page.width

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Automatic")
                    }

                    MenuItem {
                        text: qsTr("Password")
                    }
                }

            }

            PasswordField {
                id: passwordField

                label: qsTr("Password")
                visible: authMethodBox.currentIndex == 1
            }

            Rectangle {
                id: colorIndicator
                x: Theme.horizontalPageMargin
                color: Theme.highlightColor
                width: page.width - (Theme.horizontalPageMargin * 2)
                height: Theme.itemSizeExtraSmall / 2

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog");
                        dialog.accepted.connect(function() {
                            colorIndicator.color = dialog.color;
                        })
                    }
                }
            }

            Rectangle {
                width: page.width
                height: Theme.paddingMedium
                opacity: 0
            }

            Button {
                id: saveButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Save")

                onClicked: {

                    var authMethod;
                    if (authMethodBox.currentIndex == 0) authMethod = "auto";
                    if (authMethodBox.currentIndex == 1) authMethod = "password";

                    if (authMethod === "password") {
                        editServer(id, titleField.text, hostField.text, usernameField.text, paramsField.text, Number(portField.text), authMethod, null, passwordField.text, colorIndicator.color);
                    } else if (authMethod === "auto") {
                        editServer(id, titleField.text, hostField.text, usernameField.text, paramsField.text, Number(portField.text), authMethod, null, null, colorIndicator.color);
                    }

                    pageStack.pop();
                    mainPage.serversModel.update();
                }

                enabled: portField.pattern.test(portField.text)
            }

        }
    }

}
