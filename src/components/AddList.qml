import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.kirigami as Kirigami

Kirigami.Dialog {
    id: addListDialog
    title: i18nc("@title", "Add New List")
    focus: true
    onOpened: { addListField.forceActiveFocus(); }

    Controls.TextField {
        id: addListField
        text: ""
        onAccepted:  createList()
    }

    function createList() {
        let capitalized = addListField.text[0].toUpperCase();
        if (addListField.text.length > 1) capitalized += addListField.text.substr(1, addListField.text.length);
        var text = ['import org.kde.kirigami as Kirigami; Kirigami.Action {text: i18n("', capitalized, '");  onTriggered: { clearModel(); setupReminder("' + capitalized + '"); }}'].join('')
        let action = Qt.createQmlObject(text, globalDrawer, "action");
        globalDrawer.actions.push(action);

        addListField.text = "";
        addListDialog.close();
    }
}
