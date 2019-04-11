import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0 as C2
import QtQuick.Controls 2.0


Item {

    // This is a caustom Component, the main Menu
    // this will display the menu with three menu items
    // attached to right side of window

    property int buttonClicked: 0

    Rectangle
    {
        id: menubar
//        width: 420
//        height: 701
        width: parent.width * (50/100)
        height: parent.height * (90/100)
        color: "transparent"

        // property int fullwidth: 420
        property int fullwidth: parent.width * (50/100)

        anchors.verticalCenter: parent.verticalCenter


        // Component holds navigation menu item
        // each menu item has a text and image for it

        Button
        {
            id: menuitem1

            width: parent.width
            height: parent.height / 3

            background: Rectangle
            {
                color: "transparent"
                border.color: "red"
            }

            Image
            {
                id: menuitem1image

                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 1.0
                width: menuitem1.width/ 3
                height: menuitem1.height / 1.5
                source: "asserts/navigation.png"
            }
            Text {
                id: menuitem1label

                font.bold: true
                font.pixelSize: 24
                anchors.horizontalCenter: menuitem1image.horizontalCenter
                anchors.top: menuitem1image.bottom
                text: qsTr("Navigation")
            }
            onClicked: buttonClicked = 0
        }

        // Component holds driving mode menu item
        // ech menu item has a text and image for it
        Button
        {
             id: menuitem2

            anchors.top: menuitem1.bottom
            width: parent.width
            height: parent.height / 3
            anchors.topMargin: 1

            background: Rectangle
            {
                color: "transparent"
                border.color: "blue"
            }
            Image
            {
                id: menuitem2image

                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 1.0
                width: menuitem2.width/ 3
                height: menuitem2.height / 1.5
                source: "asserts/driving.png"
            }
            Text
            {
                id: menuitem2label

                font.pixelSize: 24
                font.bold: true
                anchors.horizontalCenter: menuitem2image.horizontalCenter
                anchors.top: menuitem2image.bottom
                text: qsTr("Driving Mode")
            }
            onClicked: buttonClicked = 1
        }

        // Component holds setting menu item
        // ech menu item has a text and image for it
        Button
        {
             id: menuitem3

            anchors.top: menuitem2.bottom
            width: parent.width
            height: parent.height / 3
            // color: "transparent"
            anchors.topMargin: 1
            // border.color: "yellow"

            background: Rectangle
            {
                color: "transparent"
                border.color: "yellow"
            }
            Image
            {
                id: menuitem3image

                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 1.0
                width: menuitem2.width/ 3
                height: menuitem2.height / 1.5
                source: "asserts/settings"
            }
            Text
            {
                id: menuitem3label

                font.pixelSize: 24
                font.bold: true
                anchors.horizontalCenter: menuitem3image.horizontalCenter
                anchors.top: menuitem3image.bottom
                text: qsTr("Settings")
            }

            onClicked: buttonClicked = 2
        }
    }

    // here I attache the MenuSlider to the menu, MenuSlider will
    // toggle menu slide open and slide close
    MenuSlider
    {
        id: slider
        anchors.left: menubar.right
        checked: false

        // here ever MenuSlider is clicked: it will toggel
        // the menu, either it Components become visible or invisible.
        onClicked:
        {
            checked: checked ? true : false
            menubar.width = !checked ? menubar.fullwidth : 5
            menuitem1label.visible = !checked ? true : false
            menuitem2label.visible = !checked ? true : false
            menuitem3label.visible = !checked ? true : false
        }
    }
}
