import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQml 2.2
import QtLocation 5.6
import QtPositioning 5.6
import io.simulation.weather 1.0
import QtQuick.VirtualKeyboard 2.1
import QtQuick.VirtualKeyboard.Styles 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import io.simulation.networkchecker 1.0
import QtMultimedia 5.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.1


// This is the main window for the application
// will house and display every Component created
ApplicationWindow
{
    id: root
    visible: true

    // original size
    // width: 2560 / 1.8
    // height: 1600 /1.8

    Component.onCompleted: showMaximized()

    // The main color for the app is gray, but will not affect Component
    // with inline declearation of color
    color: "gray"

    // the window for now is non-resizeable, hence min/max diamensions
    // are static
//    maximumHeight: height
//    maximumWidth: width
    minimumHeight: 500
    minimumWidth: 900

    // titile of main window,
    title: qsTr("Integrated Autonomous Vehicle")

    Timer
    {
        id: connectiontimer
        interval: 2000
        repeat: true
        running: true
        onTriggered:
        {
            var req = new XMLHttpRequest();
            req.open("GET","http://google.com",true);

            req.onreadystatechange = function()
            {
                if( req.status === 0 )
                {

                    connectivityslottext.text =  qsTr("Connectivity: Bad ")
                    connectivityslottext.color = "red"
                }
                else
                {
                    connectivityslottext.text =  qsTr("Connectivity: Good ")
                    connectivityslottext.color = "green"
                }
            }
            req.send()
        }
        Component.onCompleted: start()

    }
    // timer will update date and time
    Timer
    {
        id: timer
        interval: 1000
        repeat: true
        running: true
        onTriggered:
        {
            // timetext.text = new Date().toLocaleTimeString(Qt.formatTime("hh:mm:ss ap"))
            timetext.text =  Qt.formatTime(new Date(),"hh:mm:ss ap" )
            dateslottext.text = Qt.formatDate( new Date(), "ddd MMM d yyyy")
        }
    }


    Timer
    {
        id: loadTimer
        interval: 1000
        repeat: true
        running: false
        triggeredOnStart: false

        onTriggered:
        {
            loadIndicator.visible = true
            if( findLocation.status === GeocodeModel.Ready )
            {
                loadIndicator.visible = false
                findLocation.locate()
                stop()
            }
        }
    }

    // Weather has an appid, should not be change
    // appid is from openweathermap.org
    // appid should be replace when another is registered
    Weather
    {
        id: weather
        appId: "04db6a29809f7b4a6a004afbb29844a3"

        Component.onCompleted: weather.getWeatherInfo()
    }

    Timer
    {
        id: weathertimer

        interval: 900000
        repeat: true
        running: true

        onTriggered:
        {
            weather.getWeatherInfo()
            weatherslotweatherid.text = qsTr("Weather id: " + weather.weatherId.toFixed(0))
        }

    }

    Column
    {
        anchors.fill: parent

        // a Rectangle, a Container for the Components on the top bar
        // of window
        Rectangle
        {
            id:topbar

            width: root.width
            // height: 80
            height: root.width * (4/100)
            color: root.color

            // Component for displaying the time
            Rectangle
            {
                id: timeslot

                width: parent.width * (18.27/100)
                height: parent.height
                anchors.left: root.left
                color: Qt.lighter(topbar.color)
                border.color: Qt.lighter(color)

                QtObject {
                    property var locale: Qt.locale()
                    property date currentTime: new Date()
                    property string timeString

                    Component.onCompleted: {
                        timeString = currentTime.toLocaleTimeString(locale, Locale.ShortFormat);
                    }
                }

                Text
                {
                    id: timetext
                    anchors.centerIn: parent

                    font.pixelSize: 20
                   text: Qt.formatTime( new Date(), "hh:mm:ss ap" )
                }
            }

            // Component for displaying the date
            Rectangle
            {
                id: dateslot

                width: parent.width * (18.27/100)
                height: parent.height
                anchors.left: timeslot.right
                anchors.leftMargin: 2
                color: Qt.lighter(topbar.color)
                border.color: Qt.lighter(color)

                Text
                {
                    id: dateslottext

                    font.pixelSize: 20
                    anchors.centerIn: parent
                    text: Qt.formatDate( new Date(), "ddd MMM d yyyy")
                }
            }
            Rectangle
            {
                id: titleslot

                width: parent.width * (18.27/100)
                height: parent.height
                anchors.left: dateslot.right
                anchors.right: connectivityslot.left
                color: Qt.lighter("black")
                border.color: Qt.lighter(color)

                Text {

                    id: titleslottext
                    anchors.centerIn: parent
                    text: "Navigation"
                    font.pixelSize: 24
                    color: "white"

                }
//                Image {
//                    anchors.centerIn: parent
//                    width: parent.width / 2
//                    height: parent.height
//                    source: "asserts/LOGO.png"
//                }
            }

            // Component for displaying connectivity
            Rectangle
            {
                id: connectivityslot

                width: parent.width * (18.27/100)
                height: parent.height
                anchors.right: weatherslot.left
                anchors.rightMargin: 2
                color: Qt.lighter(topbar.color)
                border.color: Qt.lighter(color)

                Text
                {
                    id: connectivityslottext
                    font.pixelSize: 20
                    anchors.centerIn: parent
                    text: qsTr("Connectivity: Bad ")
                    color: "red"
                    font.bold: true
                }
            }

            // Component for displaying weather information
            // this component has a sunny image attachecd to it
            Rectangle
            {
                id: weatherslot

                width: parent.width * (18.27/100)
                height: parent.height
                anchors.right: parent.right
                color: Qt.lighter(topbar.color)

                border.color: Qt.lighter(color)

                Text {
                    id: weatherslotweatherid
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    text: qsTr("Weather id: " + weather.weatherId.toFixed(0) )
                }

            }
        }


        //  the Component for the middel of the window.
        //  this holds the menu and map
        Rectangle
        {
            id: middlebar

            width: root.width
            height: root.height - topbar.height - bottomcontrolbar.height
            color: root.color
            border.color: Qt.lighter(color)

            Plugin
            {
                id: mapplugin
                name: "osm"
            }

            PositionSource
            {
                active: true
                id: mylocation
            }
            Location
            {
                id: destination
                property real lon: 0.0
                property real lat: 0.0
                property string addr: ""
            }

            // This is the page for the navigation mode
            Map
            {
                id: navigationmode
                anchors.fill: parent
                plugin: mapplugin
                center: mylocation.position.coordinate
                zoomLevel: 14

                // will will hold the search input field
                // this has not be implemented yet

                InputPanel
                {
                    id: inputPanel
                    y: Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
                Rectangle
                {
                    id: searchBar
                    height: 128/3
                    width: middlebar.width * (70/100)
                    border.color: Qt.lighter("red")
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    border.width: 1

                    TextInput
                    {
                        id: searchKey
                        width: parent.width
                        height: parent.heights / 2
                        anchors.centerIn: parent
                        leftPadding: 20
                        // focus: true
                        focus: false

                        font.pixelSize: 18
                        onActiveFocusChanged: focus = true

                        onAccepted:
                        {
                            findLocation.query = text
                            findLocation.findLoc = findLocation.findLoc ? false : true
                        }
                    }
                }
                Button
                {
                    visible: false
                    id: searchResult0
                    height: 25
                    width: searchBar.width - 10
                    anchors.top: searchBar.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle
                    {
                        anchors.margins: 2
                        border.width: 1
                        border.color: "gray"
                    }

                    property real lon: 0.0
                    property real lat: 0.0
                    property string address: ""
                    property Location location: null

                    onClicked:
                    {
                        destination.addr =  searchResult0.address;
                        destination.lon = searchResult0.lon
                        destination.lat = searchResult0.lat

                        searchResult0.visible = false;
                        searchResult1.visible = false;
                        searchResult2.visible = false;

                        findLocation.setLocation( )
                    }
                }
                Button
                {
                    visible: false
                    id: searchResult1
                    height: 25
                    width: searchBar.width - 10
                    anchors.top: searchResult0.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    property real lon: 0.0
                    property real lat: 0.0
                    property string address: ""
                    property Location location: null

                    background: Rectangle
                    {
                        anchors.margins: 2
                        border.width: 1
                        border.color: "gray"
                    }

                    onClicked:
                    {
                        destination.addr =  searchResult1.address;
                        destination.lon = searchResult1.lon
                        destination.lat = searchResult1.lat

                        console.log( destination.addr )

                        searchResult0.visible = false;
                        searchResult1.visible = false;
                        searchResult2.visible = false;

                        findLocation.setLocation( )
                    }
                      
                }
                Button
                {
                    visible: false
                    id: searchResult2
                    height: 25
                    width: searchBar.width - 10
                    anchors.top: searchResult1.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    property real lon: 0.0
                    property real lat: 0.0
                    property string address: ""
                    property Location location: null

                    background: Rectangle
                    {
                        anchors.margins: 2
                        border.width: 1
                        border.color: "gray"
                    }

                    onClicked:
                    {
                        destination.addr =  searchResult2.address;
                        destination.lon = searchResult2.lon
                        destination.lat = searchResult2.lat

                        searchResult0.visible = false;
                        searchResult1.visible = false;
                        searchResult2.visible = false;

                        findLocation.setLocation( )
                    }

                }

                Rectangle
                {
                    id: loadIndicator

                    visible: false
                    width: parent.width
                    height: parent.height
                    color: "transparent"

                    anchors.centerIn: parent
                    Text {
                        id: loadIndicatorText
                        anchors.centerIn: parent
                        font.pixelSize: 30
                        font.bold: true
                        text: qsTr("Searching for location...")
                    }
                }

                MapQuickItem
                {
                    id: pointmarker
                    coordinate: mylocation.position.coordinate
                    sourceItem: Image {
                        id: pointimage
                        source: "asserts/point.png"
                        height: 25
                        width: 20
                    }

                    anchorPoint.x: pointimage.width / 2
                    anchorPoint.y: pointimage.height
                }
                MapItemView
                {
                    model:  routeModel
                    delegate: Component
                    {
                        MapRoute
                        {
                            route: routeData
                            line.color: "blue"
                            line.width: 5
                        }
                    }
                }


                GeocodeModel
                {
                    plugin: mapplugin

                    id: findLocation
                    autoUpdate: true
                    limit: 3

                    property bool findLoc: false

                    function setLocation( )
                    {
                        searchKey.text = destination.addr
                        console.log( "choosen location: ", destination.addr )
                        routeModel.updateRoute = routeModel.updateRoute ? false : true
                        reset()
                    }

                    onFindLocChanged:
                    {
                        console.log( "Current query", query)
                        searchResult0.visible = false
                        searchResult1.visible = false
                        searchResult2.visible = false

                        if( status === GeocodeModel.Loading )
                        {
                            loadTimer.start()
                        }
                        else if( status === GeocodeModel.Ready )
                        {
                            findLocation.locate()
                        }
                    }
                    function locate()
                    {
                        if( status === GeocodeModel.Ready )
                        {
                            loadIndicator.visible = false
                            console.log( "Locations are ready")
                            console.log( "Found ", count, " match for ", query )
                            if( count )
                            {

                                if( get(0) !== null )
                                {
                                    searchResult0.visible = true
                                    searchResult0.location = get(0)
                                    searchResult0.text = searchResult0.location.address.text
                                    searchResult0.address = searchResult0.location.address.text

                                    searchResult0.lon = searchResult0.location.coordinate.longitude
                                    searchResult0.lat = searchResult0.location.coordinate.latitude
                                }
                                if( get(1) !== null )
                                {
                                    searchResult1.visible = true
                                    searchResult1.location = get(1)
                                    searchResult1.text = searchResult1.location.address.text
                                    searchResult1.address = searchResult1.location.address.text

                                    searchResult1.lon = searchResult1.location.coordinate.longitude
                                    searchResult1.lat = searchResult1.location.coordinate.latitude
                                }

                                if( get(2) !== null )
                                {
                                    searchResult2.visible = true
                                    searchResult2.location = get(2)
                                    searchResult2.text = searchResult2.location.address.text
                                    searchResult2.address = searchResult2.location.address.text

                                    searchResult2.lon = searchResult2.location.coordinate.longitude
                                    searchResult2.lat = searchResult2.location.coordinate.latitude
                                }
                            }
                        }

                        update()
                    }

                    Component.onCompleted: update()
                }
                RouteModel
                {
                    id: routeModel
                    plugin: mapplugin
                    query: RouteQuery{ id: routeQuery }
                    property bool updateRoute: false
                    onUpdateRouteChanged:
                    {
                        routeQuery.clearWaypoints()
                        console.log( "Destination coor: ", destination.lat, destination.lon )
                        routeQuery.addWaypoint( mylocation.position.coordinate )
                        routeQuery.addWaypoint( QtPositioning.coordinate(destination.lat, destination.lon) )
                        update()
                        update()
                        console.log( "Destination coor: ", destination.addr )
                    }
                }

            }

            // This is the page for the driving mode
            Rectangle
            {
                visible: false
                id: drivignmode
                anchors.fill: parent
                color: parent.color
                height: parent.height
                width: parent.width

                Rectangle
                {
                    id: navigationmodetopbar
                    width: parent.width
                    height: 60
                    color: "white"
                    anchors.top: parent.top

                    Text
                    {
                        id: automodetext
                        text: qsTr("Autonomous Mode")
                        x: switchbutton.x - width - 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Switch
                    {
                        id: switchbutton
                        anchors.centerIn: parent
                    }
                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        x: switchbutton.x + switchbutton.width + 10
                        text: qsTr("On/Off")
                    }
                }

                Rectangle
                {
                    id: camarawindow
                    width: parent.width
                    height: parent.height - navigationmodetopbar.height
                    anchors.top: navigationmodetopbar.bottom
                    color: parent.color

                    Grid
                    {
                       rows: 2
                       columns: 3
                       anchors.centerIn: parent

                       Rectangle
                       {
                           // slot for camera 1
                           id: camara1
                           color: "orange"
                           border.color: Qt.lighter(color)
                           height: camarawindow.height/2
                           width: camarawindow.width/3

                           Video
                           {
                               id: camara1video
                               width: parent.width
                               height: parent.height
                               autoPlay: true
                               source: videoPath + "video1.mp4"
                               fillMode: VideoOutput.PreserveAspectCrop
                               Component.onCompleted:
                               {
                                   // console.log(videoPath)
                               }
                           }

                       }
                       Rectangle
                       {
                           // slot for camera 2
                           id: camara2
                           color: "gray"
                           border.color: Qt.lighter(color)
                           height: camarawindow.height/2
                           width: camarawindow.width/3

                           Video
                           {
                               id: camara2video
                               width: parent.width
                               height: parent.height
                               autoPlay: true
                               source: videoPath + "video2.mp4"
                               fillMode: VideoOutput.PreserveAspectCrop
                           }

                       }
                       Rectangle
                       {
                           // slot for camera 3
                           id: camara3
                           color: "brown"
                           border.color: Qt.lighter(color)
                           height: camarawindow.height/2
                           width: camarawindow.width/3

                           Video
                           {
                               id: camara3video
                               width: parent.width
                               height: parent.height
                               autoPlay: true
                               source: videoPath + "video3.mp4"
                               fillMode: VideoOutput.PreserveAspectCrop
                           }

                       }
                       Rectangle
                       {
                           // slot for camera 4
                           id: camara4
                           color: "yellow"
                           border.color: Qt.lighter(color)
                           height: camarawindow.height/2
                           width: camarawindow.width/3

                           Video
                           {
                               id: camara4video
                               width: parent.width
                               height: parent.height
                               autoPlay: true
                               source: videoPath + "video4.mp4"
                               fillMode: VideoOutput.PreserveAspectCrop
                           }
                       }
                       Rectangle
                       {
                           // slot for camera 5
                           id: camara5
                           color: "blue"
                           border.color: Qt.lighter(color)
                           height: camarawindow.height/2
                           width: camarawindow.width/3

                           Video
                           {
                               id: camara5video
                               width: parent.width
                               height: parent.height
                               autoPlay: true
                               source: videoPath + "video5.mp4"
                               fillMode: VideoOutput.PreserveAspectCrop
                           }
                       }
                       Rectangle
                       {
                           // slot for camera 6
                           id: camara6
                           color: "green"
                           border.color: Qt.lighter(color)
                           height: camarawindow.height/2
                           width: camarawindow.width/3

                           Video
                           {
                               id: camara6video
                               width: parent.width
                               height: parent.height
                               autoPlay: true
                               source: videoPath + "video6.mp4"
                               fillMode: VideoOutput.PreserveAspectCrop
                           }
                       }
                    }
                }
            }
            // This is the page for settings
            Rectangle
            {
                visible: false
                id: settingmode
                anchors.fill: parent
                color: parent.color

                Column
                {
                    anchors.centerIn: parent

                    Rectangle
                    {
                        height: 50
                        width: settingmode.width / 2
                        Row
                        {
                            height: parent.height
                            width: parent.width
                            anchors.fill: parent

                            Rectangle
                            {
                                color: Qt.lighter("gray")
                                height: parent.height
                                width: settingmode.width/4

                                Text
                                {
                                    id: stereo1text
                                    text: qsTr("OFF")
                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: stereo1switch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: stereo1switch
                                    text: qsTr("Stereo Camera 1 (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: stereo1text.right
                                    onClicked:
                                    {
                                        if( checked )
                                            stereo1text.text = "ON"
                                        else
                                            stereo1text.text = "OFF"
                                    }
                                }
                            }
                            Rectangle
                            {
                                height: parent.height
                                width: settingmode.width/4
                                color: Qt.lighter("lightgray")
                                Text
                                {
                                    id: stereo2text
                                    text: qsTr("OFF")
                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: stereo2switch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: stereo2switch
                                    text: qsTr("Stereo Camera 2 (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: stereo2text.right

                                    onClicked:
                                    {
                                        if( checked )
                                            stereo2text.text = "ON"
                                        else
                                            stereo2text.text = "OFF"
                                    }
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        height: 50
                        width: settingmode.width / 2
                        Row
                        {
                            height: parent.height
                            width: parent.width

                            anchors.centerIn: parent
                            Rectangle
                            {
                                color: Qt.lighter("gray")
                                height: parent.height
                                width: settingmode.width/4
                                Text
                                {
                                    id: monocular1text
                                    text: qsTr("OFF")
                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: monocular1switch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: monocular1switch
                                    text: qsTr("Monocular Camera 1 (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: monocular1text.right
                                    onClicked:
                                    {
                                        if( checked )
                                            monocular1text.text = "ON"
                                        else
                                            monocular1text.text = "OFF"
                                    }
                                }
                            }
                            Rectangle
                            {
                                height: parent.height
                                width: settingmode.width/4
                                color: Qt.lighter("lightgray")
                                Text
                                {
                                    id: monocular2text
                                    text: qsTr("OFF")
                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: monocular2switch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: monocular2switch
                                    text: qsTr("Monocular Camera 2 (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: monocular2text.right

                                    onClicked:
                                    {
                                        if( checked )
                                            monocular2text.text = "ON"
                                        else
                                            monocular2text.text = "OFF"
                                    }
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        height: 50
                        width: settingmode.width / 2
                        Row
                        {
                            height: parent.height
                            width: parent.width

                            anchors.centerIn: parent
                            Rectangle
                            {
                                color: Qt.lighter("gray")
                                height: parent.height
                                width: settingmode.width/4
                                Text
                                {
                                    id: lidartext
                                    text: qsTr("OFF")
                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: lidarswitch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: lidarswitch
                                    text: qsTr("Lidar Camera (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: lidartext.right
                                    onClicked:
                                    {
                                        if( checked )
                                            lidartext.text = "ON"
                                        else
                                            lidartext.text = "OFF"
                                    }
                                }
                            }

                            Rectangle
                            {
                                height: parent.height
                                width: settingmode.width/4
                                color: Qt.lighter("lightgray")
                                Text
                                {
                                    id: gnsstext
                                    text: qsTr("OFF")
                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: gnssswitch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: gnssswitch
                                    text: qsTr("GNSS/IMU Camera (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: gnsstext.right

                                    onClicked:
                                    {
                                        if( checked )
                                            gnsstext.text = "ON"
                                        else
                                            gnsstext.text = "OFF"
                                    }
                                }
                            }
                        }
                    }

                    Rectangle
                    {
                        height: 50
                        width: settingmode.width / 2
                        Row
                        {
                            height: parent.height
                            width: parent.width

                            anchors.centerIn: parent
                            Rectangle
                            {
                                color: Qt.lighter("gray")
                                height: parent.height
                                width: settingmode.width/4
                                Text
                                {
                                    id: fftext
                                    text: qsTr("OFF")

                                    horizontalAlignment: Text.AlignRight
                                    anchors.verticalCenter: ffswitch.verticalCenter
                                    width: parent.width * (15/100)
                                }
                                Switch
                                {
                                    id: ffswitch
                                    text: qsTr("Fast and Furious (ON/OFF)")
                                    width: parent.width * (75/100)
                                    anchors.left: fftext.right
                                    onClicked:
                                    {
                                        if( checked )
                                            fftext.text = "ON"
                                        else
                                            fftext.text = "OFF"
                                    }
                                }
                            }


                            Rectangle
                            {
                                height: parent.height
                                width: settingmode.width/4
                                color: Qt.lighter("lightgray")

                                Text
                                {

                                    id: maxspeedlabel
                                    anchors.left: parent.left
                                    height: parent.height
                                    width: parent.width * (50/100)
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("Set Max Speed: ")
                                    color: "#474444"
                                    font.pointSize: 14
                                    anchors.leftMargin: 20
                                }

                                Rectangle
                                {
                                    width: parent.width * (30/100)
                                    height: parent.height
                                    anchors.leftMargin: 20
                                    anchors.bottomMargin: 10
                                    border.color: Qt.lighter("black")
                                    anchors.left: maxspeedlabel.right
                                    TextInput
                                    {
                                        id: inputmaxspeed
                                        anchors.centerIn: parent
                                        width: parent.width
                                        height: parent.height / 3
                                        anchors.verticalCenterOffset: -1
                                        anchors.horizontalCenterOffset: 0
                                        leftPadding: 10
                                        focus: true
                                    }
                                }
                            }
                        }
                    }
                }
            }

            MainMenu
            {
                id: mainMenu

                // width: 420
                // height: 701
                width: middlebar.width * (50/100)
                height: middlebar.height * (90/100)
                anchors.verticalCenter: parent.verticalCenter

                onButtonClickedChanged:
                {
                    if( buttonClicked == 0 )
                    {
                        navigationmode.visible = true
                        drivignmode.visible = false
                        settingmode.visible = false
                        titleslottext.text = "Navigation"
                    }
                    else if( buttonClicked == 1 )
                    {
                        navigationmode.visible = false
                        drivignmode.visible = true
                        settingmode.visible = false
                        titleslottext.text = "Driving Mode"
                    }
                    else if( buttonClicked == 2 )
                    {
                        navigationmode.visible = false
                        drivignmode.visible = false
                        settingmode.visible = true
                        titleslottext.text = "Settings"
                    }
                }
            }

        }
        // This Rectangle will hold Components on the bottom bar of the window
        Rectangle
        {
            id: bottomcontrolbar

            width: root.width
            // height: 251
            height: root.height * (15/100)
            color: root.color


            // Dialog box will be displayed to confirm clossing of Application
            Dialog
            {
                id: closedialog
                height:100
                title: "Close application"
                standardButtons: StandardButton.Ok | StandardButton.Cancel

                onAccepted: Qt.quit()
                onRejected: this.close()

                Text {
                    font.pixelSize: 18
                    text: qsTr("Confirm to close application")
                }
            }

            // emergencey shutoff Button for clossing the app
            Button
            {
                id: emergencyshutoffslot

                width: parent.width * (25/100)
                height: parent.height
                anchors.left: parent.left
                background: Rectangle
                {
                    color: Qt.lighter("red")
                    border.color: Qt.lighter(color)
                }

                onClicked: closedialog.open()

                Text {
                    font.pixelSize: 18
                    anchors.centerIn: parent
                    elide: Text.ElideMiddle
                    text: qsTr(" Emergency shutoff: ")
                }
            }
            // Component holds slot for vehicle dynamics
            Rectangle
            {
                id: vehicledynamicsslot

                width: parent.width * (25/100)
                height: parent.height
                anchors.left: emergencyshutoffslot.right
                anchors.leftMargin: 1
                color: Qt.lighter("green")
                border.color: Qt.lighter(color)

                Text {
                    font.pixelSize: 18
                    anchors.centerIn: parent
                    elide: Text.ElideMiddle
                    text: qsTr(" Vehicle Dynamics: ")
                }
            }

            // Component holds slot for vehicle steerring bar
            Rectangle
            {
                id: vehiclesteeringbar

                width: parent.width * (25/100)
                height: parent.height
                anchors.right: batteryinformation.left
                anchors.rightMargin: 1
                color: Qt.lighter("white")
                border.color: Qt.lighter(color)

                Joystick
                {
                    anchors.centerIn: parent
                    width: parent.height
                    height: parent.height

                }
            }
            // Component holds slot for battery information
            Rectangle
            {
                id: batteryinformation

                width: parent.width * (25/100)
                height: parent.height
                anchors.right: parent.right
                color: Qt.lighter("green")
                border.color: Qt.lighter(color)

                Text {
                    font.pixelSize: 18
                    anchors.centerIn: parent
                    elide: Text.ElideMiddle
                    text: qsTr("Battery Information: ")
                }
            }
        }
    }
}
