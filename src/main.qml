import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("树形")

    Flickable {
        anchors.fill: parent
        anchors.margins: 10;

        contentWidth: width
        contentHeight: treeview.height

        boundsBehavior: Flickable.StopAtBounds

        MyTreeView {
            id: treeview
        }

        ScrollBar.vertical: ScrollBar
        {
            id: vbar;
            policy: ScrollBar.AlwaysOn;
        }
    }
}
