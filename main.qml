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

// This is the main window for the application
// will house and display every Component created
ApplicationWindow
{
    id: root
    visible: true

    width: 2560 / 2
    height: 1600 / 2

    // The main color for the app is gray, but will not affect Component
    // with inline declearation of color
    color: "gray"

    // the window for now is non-resizeable, hence min/max diamensions
    // are static
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

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
            console.log("loadtimer now running")
            loadIndicator.visible = true
            if( findLocation.status === GeocodeModel.Ready )
            {
                loadIndicator.visible = false
                console.log("loadtimer will stop")
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

//            weatherslotc1text.text = qsTr( "Lon: " + weather.longitude.toFixed(1) +
//                                           "\nLat: " + weather.latitude.toFixed(1) +
//                                           "\nLoc: " + weather.cityName )
//            weatherslotc2text.text = qsTr( "Temp: " + weather.temperature.toFixed(1) +
//                                           "\nWind: " + weather.wind.toFixed(1) +
//                                           "\nHumd: " + weather.humidity.toFixed(0) )
//            weatherslotweathername.text = weather.weatherDescription

//            weatherslotimage.source = "http://openweathermap.org/img/w/" + weather.imgCode + ".png"

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
            height: 40
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

                    font.pixelSize: 18
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

                    font.pixelSize: 18
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
                color: "black"
                border.color: Qt.lighter(color)

                Image {
                    anchors.centerIn: parent
                    width: parent.width / 2
                    height: parent.height
                    source: "asserts/LOGO.png"
                }
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
                    font.pixelSize: 18
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

//                Column
//                {
//                    id: weatherslotc1

//                    anchors.verticalCenter: parent.verticalCenter
//                    height: parent.height
//                    width: parent.width / 3
//                    Text
//                    {
//                        // anchors.fill: parent
//                        id: weatherslotc1text
//                        font.pointSize: 12
//                        text: qsTr( "Lon: " + weather.longitude.toFixed(1) +
//                                    "\nLat: " + weather.latitude.toFixed(1) +
//                                    "\nLoc: " + weather.cityName )
//                    }
//                }
//                Column
//                {
//                    id: weatherslotc2
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    anchors.left: weatherslotc1.right
//                    height: parent.height
//                    width: parent.width / 3
//                    Text
//                    {
//                        id: weatherslotc2text

//                        height: weatherslot.height
//                        font.pointSize: 12
//                        text: qsTr( "Temp: " + weather.temperature.toFixed(1) +
//                                    "\nWind: " + weather.wind.toFixed(1) +
//                                    "\nHumd: " + weather.humidity.toFixed(0) )
//                    }
//                }
//                Image
//                {
//                    id: weatherslotimage

//                    anchors.top: parent.top
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    height: parent.height / 1.4
//                    width: parent.width / 1.4

//                    source: "http://openweathermap.org/img/w/" + weather.imgCode + ".png"
//                    Text {

//                        id: weatherslotweathername

//                        font.pointSize: 14
//                        anchors.horizontalCenter: weatherslotimage.horizontalCenter
//                        anchors.top: weatherslotimage.bottom
//                        text: weather.weatherDescription
//                    }
//                }

                Text {
                    id: weatherslotweatherid
                    anchors.centerIn: parent
                    font.pixelSize: 18
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
            height: 548
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
                Component.onCompleted:
                {
                    console.log("Device positioning mdethod",  valid )
                }
            }
            Location
            {
                id: destination
                property real lon: 0.0
                property real lat: 0.0
                property string addr: ""
            }

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
                    width: 1870/2
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

                    console.log( status, errorString, "ready: ", GeocodeModel.Ready )

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

            // this is the page for the driving mode
            Rectangle
            {
                visible: false
                id: drivignmode
                anchors.fill: parent
                color: parent.color
                height: parent.height
                width: parent.width
                Text {
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    text: qsTr("Driving mode")
                }
                Joystick
                {
                    anchors.right: parent.right
                    anchors.rightMargin: 100
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 100
                }
            }
            // this is the page for settings
            Rectangle
            {
                visible: false
                id: settingmode
                anchors.fill: parent
                color: parent.color
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 40
                    text: qsTr("Settings")
                }
            }

            MainMenu
            {
                id: mainMenu

                width: 420/2
                height: 701/2
                anchors.verticalCenter: parent.verticalCenter

                onButtonClickedChanged:
                {
                    if( buttonClicked == 0 )
                    {
                        navigationmode.visible = true
                        drivignmode.visible = false
                        settingmode.visible = false
                    }
                    else if( buttonClicked == 1 )
                    {
                        navigationmode.visible = false
                        drivignmode.visible = true
                        settingmode.visible = false
                    }
                    else if( buttonClicked == 2 )
                    {
                        navigationmode.visible = false
                        drivignmode.visible = false
                        settingmode.visible = true
                    }

                }
            }

        }
        // this Rectangle will hold Components on the bottom bar of the window
        Rectangle
        {
            id: bottomcontrolbar

            width: root.width
            height: 251/2
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
                color: Qt.lighter("green")
                border.color: Qt.lighter(color)

                Text {
                    font.pixelSize: 18
                    anchors.centerIn: parent
                    elide: Text.ElideMiddle
                    text: qsTr(" Vehicle Steering Bar: ")
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
