import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.example.todor.components

Kirigami.ApplicationWindow {
    id: application
    title: i18nc("@title:window", "ToDo:R")

    globalDrawer: Kirigami.GlobalDrawer {
        id: globalDrawer
        title: i18n("Reminders")

        AddList {
            id: addListDialog
        }

        Controls.Button {
            text: "Add new list"
            Layout.alignment: Qt.AlignHCenter
            icon.name: "list-add-symbolic"
            onClicked: {
                addListDialog.open();
            }
        }

        actions: [
            Kirigami.Action {
                text: i18n("Groceries")
                onTriggered: {
                    clearModel();
                    reminderModel.append({
                        task: "Test 1",
                        note: "",
                        finished: "false",
                        isNew: "true"
                    });
                    reminderModel.append({
                        task: "Test 2",
                        note: "This is not needed",
                        finished: "true",
                        isNew: "true"
                    });
                    setupReminder("Groceries");
                }
            },
            Kirigami.Action {
                text: i18n("Programming")
                onTriggered: {
                    clearModel();
                    reminderModel.append({
                        task: "Read these lists from file",
                        note: "",
                        finished: "false",
                        isNew: "true"
                    });
                    setupReminder("Programming");
                }
            },
            Kirigami.Action {
                text: i18n("Reminders")
                onTriggered: {
                    clearModel();
                    reminderModel.append({
                        task: "Feed cat",
                        note: "Use dry food",
                        finished: "false",
                        isNew: "true"
                    });
                    reminderModel.append({
                        task: "Wash clothes",
                        note: "",
                        finished: "false",
                        isNew: "true"
                    });
                    setupReminder("Reminders");
                }
            }
        ]
    }

    function clearModel() {
        for (var i = (reminderModel.count - 1); i >= 0; i--) {
            reminderModel.remove(i, 1);
        }
    }

    function setupReminder(reminderListName) {
        titleText = reminderListName

        let completed = 0;
        for (var i = 0; i < reminderModel.count; i++)  {
            if (reminderModel.get(i).finished == "true") completed++;
        }
        completedTasks = completed
    }

    property var completedTasks: 0
    property var titleText: ""

    ListModel {
        id: reminderModel
    }

    pageStack.initialPage: Kirigami.ScrollablePage {
        title: i18nc("@title", titleText + " (" + completedTasks + " completed)")

        actions: [
            Kirigami.Action {
                id: clearAction
                text: i18nc("@action:button", "Clear")
                tooltip: i18n("Clear completed")
                onTriggered: {
                    for (var i = (reminderModel.count - 1); i >= 0; i--) {
                        if (reminderModel.get(i).finished == "true") {
                            reminderModel.remove(i, 1);
                        }
                    }
                    completedTasks = 0;
                }
                enabled: (completedTasks > 0) ? true: false
            },
            Kirigami.Action {
                id: addAction
                icon.name: "list-add-symbolic"
                text: i18nc("@action:button", "New reminder")
                tooltip: i18n("Add new empty reminder")
                onTriggered: {
                    if (reminderModel.count > 0 && reminderModel.get(reminderModel.count - 1).task == "") {
                        return;
                    }

                    reminderModel.append({
                        task: "",
                        note: "",
                        finished: "false",
                        isNew: "true"
                    });
                }
            }
        ]

        Kirigami.CardsListView {
            id: cardsView
            model: reminderModel
            delegate: ItemsList {}
            onCountChanged: {
                let child = cardsView.itemAtIndex(cardsView.count - 1);
                if (child) {
                    let item = child.children[0].children[0].children[0].children[0];
                    let gridLayout = item.children[0];
                    let columnLayout = gridLayout.children[1]
                    let taskTextField = columnLayout.children[0];

                    if (taskTextField.placeholderText == "") {
                        taskTextField.text = "";
                        taskTextField.forceActiveFocus();
                    }
                }
            }
        }
    }
}
