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
                title: qsTr("Add server")
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

        PullDownMenu {
            MenuItem {
                text: qsTr("Import from ~/.ssh")
                onClicked: {
                    var dlg = pageStack.push(knownHostsPicker)
                    dlg.accepted.connect(function() {
                        titleField.text = dlg.selectedHost.userName ? (dlg.selectedHost.userName + "@" + dlg.selectedHost.hostName) : dlg.selectedHost.hostName
                        hostField.text = dlg.selectedHost.hostName
                        usernameField.text = dlg.selectedHost.userName ? dlg.selectedHost.userName : ""
                        portField.text = dlg.selectedHost.port ? dlg.selectedHost.port : 22
                    })
                }
            }
        }
    }

    Component {
        id: knownHostsPicker
        Dialog { id: knownHostsDialog
            readonly property string clientConf: Qt.resolvedUrl(StandardPaths.home + "/.ssh/config")
            readonly property string knownHosts: Qt.resolvedUrl(StandardPaths.home + "/.ssh/known_hosts")

            property var selectedHost: ({})
            property int selectedIdx: -1

            onAccepted: selectedHost = new Object(hostsModel.get(selectedIdx))
            canAccept:  selectedIdx != -1

            ListModel { id: hostsModel }

            SilicaListView {
                anchors.fill: parent
                header: DialogHeader {}
                section.property: "source"
                section.delegate: SectionHeader { text: qsTr("From: %1").arg(section) }
                model: hostsModel
                delegate: ListItem {
                    width: ListView.view.width - Theme.horizontalPageMargin
                    anchors.horizontalCenter: parent.horizontalCenter

                    property bool selected: index == knownHostsDialog.selectedIdx
                    highlighted: down || selected

                    onClicked: {
                        knownHostsDialog.selectedIdx = selected ? -1 : index
                        knownHostsDialog.selectedHost = new Object(hostsModel.get(index))
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        Label {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: hostName
                        }
                        Label {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: userName ? (qsTr("Username") + ": " + userName) : ""
                            color: Theme.secondaryColor
                            font.pixelSize: Theme.fontSizeSmall
                        }
                    }
                }
                ViewPlaceholder {
                    enabled: hostsModel.count < 1
                    text: qsTr("No hosts found.")
                    hintText: qsTr("Your ~/.ssh directory contains no files to read hosts from.")
                }
                VerticalScrollDecorator {}
            }
            Component.onCompleted: {
                /* Retrieve a list of hostname candidates from Host entries in
                 * ~/.ssh/config and ~/.ssh/known_hosts
                 *
                 * Make sure to use the same schema of object properties, or
                 * else the ListModel will not accept mixed entries (dynamicRoles)
                 */
                var config_xhr = new XMLHttpRequest()
                config_xhr.onreadystatechange = function() {
                    if (config_xhr.readyState === XMLHttpRequest.DONE) {
                        const hosts = config_xhr.responseText.split("\n").map(function(elem, idx, arr) {
                            var line = elem.trim() // entries may be indented
                            var o = {}
                            o["source"] = qsTr("SSH Config")
                            if (/^[Hh]ost\s+/.test(line)) { // careful: several keywords can start with Host, we want only Host
                                o["hostName"] = line.split(/\s+/)[1]
                                // A section starting with Host or Match may contain a hint about the username
                                // look 10 lines ahead (randomly chosen limit)
                                for (var i=1; i<=10; i++) {
                                    const ln = arr[idx+i].trim()
                                    if (!ln) break                         // end of file
                                    if (/^(Host|Match)\s+/.test(ln)) break // next section reached
                                    const user = ln.match(/^[Uu]ser\s+(\w+)$/)
                                    if (user && user[1]) {
                                        o["userName"] = user[1]
                                        break                              // found
                                    }
                                }
                            }
                            if (o.hostName) { return o }
                        })
                        // map may contain undefined, filter those:
                        hosts.forEach(function(e) { if (e) hostsModel.append(e) })
                    }
                }
                config_xhr.open("GET", clientConf);
                config_xhr.send();

                var known_xhr = new XMLHttpRequest()
                known_xhr.onreadystatechange = function() {
                    if (known_xhr.readyState === XMLHttpRequest.DONE) {
                        var hosts = known_xhr.responseText.split("\n").map(function(line, idx, arr) {
                           return line.split(/\s+/)[0] // format: host keytype key comment
                        // sort and remove duplicates:
                        }).sort().filter(function(item,pos,self) { return self.indexOf(item) == pos })
                        hosts.forEach(function(host) {
                            var o = {}
                            o["hostName"] = host
                            o["userName"] = ""
                            o["source"] = qsTr("Known Hosts")
                            hostsModel.append(o)
                        })
                    }
                }
                known_xhr.open("GET", knownHosts);
                known_xhr.send();
            }
        }
    }
}
