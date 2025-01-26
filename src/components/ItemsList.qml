import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.AbstractCard {
    id: abstractCard
    background: Rectangle { color: "transparent" }
    padding: 0

    contentItem: Item {
        implicitWidth: delegateLayout.implicitWidth
        implicitHeight: delegateLayout.implicitHeight

        GridLayout {
            id: delegateLayout
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            rowSpacing: Kirigami.Units.largeSpacing
            columnSpacing: Kirigami.Units.largeSpacing
            columns: 2

            Controls.CheckBox {
                Layout.alignment: Qt.AlignHCenter
                checked: finished == "true" ? true : false
                onClicked: updateFinishedTasks(index)
                padding: 0
            }

            ColumnLayout {
                Controls.TextField {
                    id: taskField
                    placeholderText: task
                    background: Rectangle { color: "transparent" }
                    Layout.fillWidth: true
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.2
                    focus: task == "" ? true : false
                    onFocusChanged: focusHasChanged(index, focus, "task")
                    onAccepted: { taskField.focus = false; }
                    padding: 0
                }
                Controls.TextField {
                    id: noteField
                    placeholderText: note.length > 0 ? note : taskField.focus == true ? "Add Note" : ""
                    Layout.fillWidth: true
                    visible: (note.length > 0 || taskField.focus == true || noteField.focus == true)
                    background: Rectangle { color: "transparent" }
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.5
                    onFocusChanged: focusHasChanged(index, focus, "note")
                    onAccepted: { noteField.focus = false; }
                    padding: 0
                }
            }
        }
    }

    function focusHasChanged (index, focus, prop) {
        if (focus) {
            if (prop == "task") {
                taskField.text = taskField.placeholderText;
            } else if (prop == "note") {
                noteField.text = noteField.placeholderText;
            }
        } else {
            updateValue(index, prop);
        }
    }

    function updateValue (index, prop) {
        let value = "";
        if (prop == "task") {
            value = taskField.text;
            taskField.text = "";
            taskField.focus = false;
        } else if (prop == "note") {
            value = noteField.text;
            noteField.text = "";
            noteField.focus = false;
        }
        if (value == "" && prop == "task") {
            reminderModel.remove(index);
        } else {
            reminderModel.setProperty(index, prop, value);
        }
    }

    function updateFinishedTasks(index) {
        // Toggle clicked tasks
        let object = reminderModel.get(index);
        let finished = "true";
        if (object.finished == "true") finished = "false";
        reminderModel.setProperty(index, "finished", finished);

        // Count all the finished tasks
        let completed = 0;
        for (var i = 0; i < reminderModel.count; i++)  {
            if (reminderModel.get(i).finished == "true") completed++;
        }
        completedTasks = completed
    }
}
