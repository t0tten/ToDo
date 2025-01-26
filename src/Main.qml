import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami
import org.example.todor.components

Kirigami.ApplicationWindow {
    id: application

    title: i18nc("@title:window", "ToDor")

    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("Reminders")
        actions: [
            Kirigami.Action {
                text: i18n("Groceries")
                //onTriggered: Qt.quit()
            }
        ]
    }

    property var completedTasks: 0

    ListModel {
        id: reminderModel

        ListElement {
            task: "Test1"
            note: ""
            finished: "false"
        }
        ListElement {
            task: "Test2"
            note: "Not needed"
            finished: "false"
        }
    }

    pageStack.initialPage: Kirigami.ScrollablePage {
        title: i18nc("@title", "Groceries (" + completedTasks + " completed)")

        actions: [
            Kirigami.Action {
                id: addAction
                icon.name: "list-add-symbolic"
                text: i18nc("@action:button", "New reminder")
                onTriggered: {
                    reminderModel.append({
                        task: "",
                        note: "",
                        finished: "false"
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
                        taskTextField.forceActiveFocus();
                    }
                }
            }
        }
    }
}
