import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.5
import "pages"
import "cover"

ApplicationWindow {

    id: applicationWindow

    function getDatabase() {
        return LocalStorage.openDatabaseSync("wunderssh", "1.0", "WunderSSH", 1000000);
    }

    function initDatabase() {
        var db = getDatabase();
        db.transaction(
            function(tx) {
//                tx.executeSql('DROP TABLE IF EXISTS servers');
                tx.executeSql('CREATE TABLE IF NOT EXISTS servers (id integer PRIMARY KEY, title TEXT, host TEXT, username TEXT, params TEXT, port INT, auth_method TEXT, pubkey TEXT, password TEXT, color TEXT)');
            }
        )
    }

    function getServers() {
        var db = getDatabase();
        var result;
        db.transaction(
            function(tx) {
                result = tx.executeSql('SELECT * FROM servers');
            }
        )

        return result
    }

    function getServer(id) {
        var db = getDatabase();
        var result;
        db.transaction(
            function(tx) {
                result = tx.executeSql('SELECT * FROM servers WHERE id = ?', [id]);
            }
        )

        return result;
    }

    function addServer(title, host, username, ssh_args, port, authMethod, pubkey, password, color) {
        var db = getDatabase();

        if (["auto", "pubkey", "password"].indexOf(authMethod) === -1) { return null }

        db.transaction(
            function(tx) {
                var query = "INSERT INTO servers VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                var query_params = [title, host, username, ssh_args, port, authMethod];
                query_params.push(typeof pubkey !== 'undefined' ? pubkey : null);
                query_params.push(typeof password !== 'undefined' ? password : null);
                query_params.push(color)
                tx.executeSql(query, query_params)
            }
        )
    }

    function editServer(id, title, host, username, ssh_args, port, authMethod, pubkey, password, color) {
        var db = getDatabase();

        if (["auto", "pubkey", "password"].indexOf(authMethod) === -1) { return null }

        db.transaction(
            function(tx) {
                var query = "UPDATE servers SET title = ?, host = ?, username = ?, params = ?, port = ?, auth_method = ?, pubkey = ?, password = ?, color = ? WHERE id = ?";
                var query_params = [title, host, username, ssh_args, port, authMethod];
                query_params.push(typeof pubkey !== 'undefined' ? pubkey : null);
                query_params.push(typeof password !== 'undefined' ? password : null);
                query_params.push(color)
                query_params.push(Number(id))
                tx.executeSql(query, query_params)
            }
        )
    }

    function removeServer(id) {
        var db = getDatabase();

        db.transaction(
            function(tx) {
                var query = "DELETE FROM servers WHERE id=?";
                var query_params = [id];
                tx.executeSql(query, query_params);
            }
        )
    }

    Python {
        id: python
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("python/."))
            importModule("backend", function () {})
        }
    }

    function connectToServer(id) {
        var result = getServer(Number(id));
        var server = result.rows.item(0)

        var args = ["/usr/bin/fingerterm", server.host, server.username, server.params, server.port]
        if (server.auth_method === "password") {
            args.push("")
            args.push(server.password)
        }

        python.call("backend.run_session", args)
    }

    AboutPage {
        id: aboutPage
    }

    AddPage {
        id: addPage
    }

    MainPage {
        id: mainPage
    }

    EditPage {
        id: editPage
    }

    SettingsPage {
        id: settingsPage
    }

    Timer {
        id: timer
    }

    function delay(delayTime, callback) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(callback);
        timer.start();
    }

    CoverPage {
        id: coverPage
    }

    initialPage: mainPage


    Component.onCompleted: {
        initDatabase();
        var result = getServers();
        mainPage.serversModel.update();
        mainPage.busyIndicator.running = false;
        mainPage.listView.visible = true;
    }

    cover: coverPage
    allowedOrientations: defaultAllowedOrientations
}
