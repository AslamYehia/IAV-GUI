import QtQuick 2.0
// import io.simulation.joycontroler 1.0

Item
{
// this is a wrapper for the actuall real controler
// comment it out since Joystick library has not been added
//    JoyControler
//    {
//        id: realjoycontroler
//    }

    // ui display of controler position
    Rectangle
    {
        id: boundery

        width: parent.height
        height: parent.height

        color: "transparent"
        radius: height
        border { width:1; color: "red" }

        anchors.centerIn: parent


        Rectangle
        {
            id: ball
            width: parent.width / 2
            height: parent.height / 2
            color: "seagreen"
            property point beginDrag
            border { width:1; color: "white" }
            radius: height
            opacity: 0.5
            Drag.active: mouseArea.drag.active

            x: parent.x + (width / 2)
            y: parent.y + (height / 2)


            MouseArea
            {
                id: mouseArea
                anchors.fill: parent
                drag.target: parent

                drag.maximumX: boundery.width - ball.width
                drag.maximumY: boundery.height - ball.height
                drag.minimumX: 0
                drag.minimumY: 0

                onReleased:
                {
                    backAnimX.from = ball.x;
                    backAnimX.to = ball.parent.x + (ball.width / 2)
                    backAnimY.to = ball.parent.y + (ball.height / 2)
                    backAnim.start()

                    ball.x = ball.parent.x + (ball.width / 2)
                    ball.y = ball.parent.y + (ball.height / 2)
                }

            }
            ParallelAnimation
            {
                id: backAnim
                SpringAnimation { id: backAnimX; target: ball; property: "x"; duration: 500; spring: 1; damping: 0.2 }
                SpringAnimation { id: backAnimY; target: ball; property: "y"; duration: 500; spring: 1; damping: 0.2 }
            }

//            // update controler ui tracker every 0.1ms
//            Timer
//            {
//                id: timer
//                interval: 10
//                repeat: true
//                running: true
//                onTriggered:
//                {
//                    realjoycontroler.getPositions()
//                    ball.x = ball.x + realjoycontroler.posX
//                    ball.y = ball.y + realjoycontroler.posY
//                }
//            }

//            comment this in when JoyControler is present

//            Component.onCompleted:
//            {
//                realjoycontroler.getPositions()
//                ball.x = ball.x + realjoycontroler.posX
//                ball.y = ball.y + realjoycontroler.posY
//                ball.x = ball.x + 1;
//                ball.y = ball.y + 1;
//            }
        }
    }
}
