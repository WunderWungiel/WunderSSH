import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    function reset() {
        titleField.text = ""
        hostField.text = ""
        usernameField.text = ""
        paramsField.text = ""
        portField.text = "22"
        authMethodBox.currentIndex = 0
        passwordField.text = ""
        colorIndicator.color = Theme.highlightColor
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            width: page.width
            id: column
            spacing: Theme.paddingSmall

            PageHeader {
                title: "Add server"
            }

            TextField {
                id: titleField
                label: "Title"
                acceptableInput: text.length > 0

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: hostField.focus = true
            }

            TextField {
                id: hostField
                label: "Host"
                acceptableInput: text.length > 0

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: usernameField.focus = true
            }

            TextField {
                id: usernameField
                label: "Username"
                acceptableInput: text.length > 0

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: paramsField.focus = true
            }

            TextArea {
                id: paramsField
                label: "Params"

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: portField.focus = true
            }

            TextField {
                id: portField
                property var pattern: new RegExp(/^\d+$/)

                text: "22"
                label: "Port"
                acceptableInput: pattern.test(text)
                inputMethodHints: Qt.ImhDigitsOnly
            }

//            ValueButton {
//                anchors.horizontalCenter: parent.horizontalCenter
//                label: "Pubkey"
//                value: selectedPubkey
//                onClicked: pageStack.animatorPush(filePickerPage)
//            }

            ComboBox {

                id: authMethodBox
                label: "Authentication method"
                width: page.width

                menu: ContextMenu {
                    MenuItem {
                        text: "Automatic"
                    }

                    // MenuItem {
                    //     text: "Custom pubkey file"
                    // }

                    MenuItem {
                        text: "Password"
                    }
                }

            }

            PasswordField {
                id: passwordField

                label: "Password"
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
                text: "Save"

                onClicked: {

                    var authMethod;
                    if (authMethodBox.currentIndex == 0) authMethod = "auto";
                    if (authMethodBox.currentIndex == 1) authMethod = "password";

                    if (authMethodBox.currentIndex == 1) {
                        addServer(titleField.text, hostField.text, usernameField.text, paramsField.text, Number(portField.text), authMethod, null, passwordField.text, colorIndicator.color);
                    } else if (authMethodBox.currentIndex == 0) {
                        addServer(titleField.text, hostField.text, usernameField.text, paramsField.text, Number(portField.text), authMethod, null, null, colorIndicator.color);
                    }

                    pageStack.pop();
                    mainPage.serversModel.update();
                }

                enabled: portField.pattern.test(portField.text)
            }

        }
    }

}
