// import QtQuick 2.0
import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.0 as C2
import QtQuick 2.5


/**

  MenuSlider is the menu indicator and is responsible for
  revealing and hiding the menu

  **/
Button
{
    id: sliderToggler
    width: 32
    height: 96
    checkable: true
    property alias checked: sliderToggler.checked
    anchors.verticalCenter: parent.verticalCenter

    transform:  Scale
    {
        //s origin.x: rightEdge() ? 0 : sliderToggler.width / 2
        //s xScale: rightEdge() ? 1 : -1
    }

    style:  ButtonStyle
    {
        background: Rectangle
        {
            color: "transparent"
        }
    }

    property real shear: 0.333
    property real buttonOpacity: 0.5
    //s property real mirror : rightEdge() ? -1.0 : 1.0

    // there are two part for the MenuSlider
    Rectangle
    {
        width: 16
        height: 48
        color: "seagreen"
        antialiasing: true
        opacity: sliderToggler.buttonOpacity
        anchors.top: parent.top
        anchors.left: sliderToggler.checked ?  parent.left : parent.horizontalCenter
        transform: Matrix4x4
        {
            property real d : sliderToggler.checked ? 1.0 : -1.0
            matrix:    Qt.matrix4x4(1.0,  d * sliderToggler.shear,    0.0,    0.0,
                                    0.0,    1.0,    0.0,    0.0,
                                    0.0,    0.0,    1.0,    0.0,
                                    0.0,    0.0,    0.0,    1.0)
        }
    }

    Rectangle
    {
        width: 16
        height: 48
        color: "seagreen"
        antialiasing: true
        opacity: sliderToggler.buttonOpacity
        anchors.top: parent.verticalCenter
        anchors.right: sliderToggler.checked ?  parent.right : parent.horizontalCenter
        transform: Matrix4x4
        {
            property real d : sliderToggler.checked ? -1.0 : 1.0
            matrix:    Qt.matrix4x4(1.0,  d * sliderToggler.shear,    0.0,    0.0,
                                    0.0,    1.0,    0.0,    0.0,
                                    0.0,    0.0,    1.0,    0.0,
                                    0.0,    0.0,    0.0,    1.0)
        }
    }
}
