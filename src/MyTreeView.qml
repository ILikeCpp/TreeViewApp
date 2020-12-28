import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Item {
    id: root;
    width: parent.width
    height: view.height

    property int currentRow: -1;
    property var curIndex: null;
    property bool isAdd: false;
    property int rowCount: 1;

    Dialog {
        id: inputDialog
        visible: false
        width: 200;
        height: 100;

        standardButtons: StandardButton.Save | StandardButton.Cancel

        Rectangle {
            id: rect;
            width: parent.width-10;
            height: textInput.height + 10;
            anchors.centerIn: parent;
            border.width: 1;
            border.color: "black"
            clip: true;

            TextInput {
                id: textInput
                cursorVisible: false
                anchors.left: parent.left;
                anchors.leftMargin: 5
                anchors.right: parent.right;
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                selectByMouse: true;
            }
        }

        onAccepted: {
            if (isAdd)
            {
                treeModel.insertRows(0,1,curIndex);
                var index = treeModel.index(0,0, curIndex);
                treeModel.setData(index, textInput.text);
                view.expand(curIndex);
                root.rowCount++;
            }
            else
            {
                treeModel.setData(curIndex,textInput.text);
            }
        }
    }

    Menu {
        id: menu
        visible: false;

        MenuItem {
            text: "增加"
            onTriggered: {
                isAdd = true;
                inputDialog.title = "增加";
                inputDialog.open();
            }
        }

        MenuItem {
            text: "删除"
            onTriggered: {
                var count = treeModel.childrenCount(curIndex);
                console.debug("count === ",count);
                treeModel.removeRows(curIndex.row,1,treeModel.parent(curIndex));
                root.rowCount -= (count+1);
            }
        }

        MenuItem {
            text: "修改"
            onTriggered: {
                isAdd = false;
                inputDialog.title = "修改";
                inputDialog.open();
            }
        }
    }

    TreeView {
        id: view
        width: parent.width - 20;
        anchors.horizontalCenter: parent.horizontalCenter;
        height: root.rowCount * 25;
        model: treeModel
        headerVisible:false

        TableViewColumn {
            title: "Name"
            role: "name"
            resizable: true
        }

        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        itemDelegate: Item {
            id: item;
            property var values: styleData.value

            onValuesChanged: {
                console.debug(values);
                if (values === "")
                {
                    checkbox.checkedState = Qt.Unchecked;
                    return;
                }

                if (styleData.column === 0)
                {
                    checkbox.checkedState = parseInt(item.values[1]);
                }

                contentText.text = item.values[0]
            }

            MouseArea {
                enabled: styleData.row !== undefined
                anchors.fill: parent;
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: {
                    currentRow = styleData.row;
                    if (mouse.button === Qt.RightButton)
                    {
                        curIndex = styleData.index;
                        menu.popup();
                    }
                }

                onDoubleClicked: {
                    if (view.isExpanded(styleData.index))
                    {
                        view.collapse(styleData.index)
                    }
                    else
                    {
                        view.expand(styleData.index);
                    }
                }
            }

            CheckBox {
                id: checkbox
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter
                text: ""
                checkedState: Qt.Unchecked
                visible: styleData.column === 0

                onClicked: {
                    treeModel.updateCheckState(styleData.index, checked);
                }
            }

            Text {
                id: contentText
                anchors.left: checkbox.right;
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
                color: styleData.textColor
                elide: styleData.elideMode
            }
        }

        rowDelegate: Rectangle{
            width: parent.width;
            height: 25;
            color: {
                if (styleData.row === undefined) {
                    return "#ececec";
                }

                if (styleData.row === currentRow) {
                    return "blue";
                }
                else if (styleData.alternate) {
                    return "#CEDFF7";
                }
                else {
                    return "#ececec";
                }
            }
        }

        onDoubleClicked : {
            if (view.isExpanded(index))
            {
                view.collapse(index)
            }
            else
            {
                view.expand(index);
            }
        }
    }
}
