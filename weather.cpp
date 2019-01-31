#include "weather.h"
#include <QEventLoop>

// initialise the weather object
Weather::Weather(QObject *parent, QString appid ) : QObject(parent)
{
    this->openMapUrl.append( "https://api.openweathermap.org/data/2.5/weather?" );
    this->appId = appid;
    this->m_cityName = nullptr;
    this->m_temperature = 0.0;
    this->m_latitude = 0.0;
    this->m_longitude = 0.0;
    this->m_humidity = 0.0;
    this->m_weatherDescription = nullptr;
    this->m_imgCode = nullptr;
    this->m_weatherId = 0;
}

// this method will get the longitude and latitude of the current location
QMap<QString, double> Weather::getCoordinate()
{
    QGeoPositionInfoSource * positionLocationSource;

    positionLocationSource = QGeoPositionInfoSource::createDefaultSource( new QObject() );

    positionLocationSource->setPreferredPositioningMethods(QGeoPositionInfoSource::NonSatellitePositioningMethods);

    positionLocationSource->startUpdates();

    QGeoPositionInfo positionInfo = positionLocationSource->lastKnownPosition();

    double latitude = positionInfo.coordinate().latitude();
    double longitude = positionInfo.coordinate().longitude();

    QMap<QString, double> map;

    map.insert( QString("lat"), latitude );
    map.insert( QString("lon"), longitude );

    // set the longitude and latitude in the property field
    this->m_latitude = latitude;
    this->m_longitude = longitude;

    // emit this singls for notify change
    emit this->latitudeChanged();
    emit this->longitudeChanged();

    return map;
}

// this will get the weather info from openweathermap.org via their
// api using the longitude and latitude
void Weather::getWeatherInfo( )
{
    QMap<QString, double> map = this->getCoordinate();

    QNetworkAccessManager * manager = new QNetworkAccessManager();

    QString compose;

    // compose the request, has to be right
    compose.append( this->openMapUrl );
    compose.append( "lat=" + QString::number(map["lat"], 'f', 4) );
    compose.append("&");
    compose.append( "lon=" + QString::number(map["lon"], 'f', 4) );
    compose.append("&");
    compose.append( "appid=" + this->appId );

    QUrl url( compose );

    // send request and wait for reply
    QNetworkReply * reply = manager->get( QNetworkRequest(url) );

    QEventLoop eventLoop;
    connect(reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();

    reply->startTimer( 1000, Qt::CoarseTimer );
    QString st( reply->readAll() );
    QJsonDocument doc = QJsonDocument::fromJson(st.toUtf8());

    QJsonObject obj = doc.object();

    // get only the details we want to display
    this->m_cityName = obj["name"].toString();
    this->m_temperature = obj["main"].toObject()["temp"].toDouble();
    this->m_humidity = obj["main"].toObject()["humidity"].toDouble();
    this->m_wind = obj["wind"].toObject()["speed"].toDouble();


    QJsonArray weatherarray = obj["weather"].toArray();
    QJsonObject weatherobject =  weatherarray[0].toObject();
    this->m_weatherDescription = weatherobject["description"].toString();
    this->m_imgCode = weatherobject["icon"].toString();
    this->m_weatherId = weatherobject["id"].toDouble();

    // emit neccesary signals
    emit this->dataRead();
    emit this->cityNameChanged();
    emit this->temperatureChanged();
    emit this->weatherDescriptionChanged();
    emit this->humidityChanged();
    emit this->windChanged();
    emit this->imgCodeChanged();
    emit this->weatherIdChanged();


    return;
}

// get weather description eg sunny, haze, mist
QString Weather::weatherDescription()
{
    return this->m_weatherDescription;
}

// return city name
QString Weather::cityName()
{
    return this->m_cityName;
}

// return image code
QString Weather::imgCode()
{
    return this->m_imgCode;
}

// return temperature in celsius
qreal Weather::temperature()
{
    // covert temperature from kelvin to celsius
    return this->m_temperature - 273.15;
}

// set the appid aka auth key
void Weather::setAppId( QString id )
{
    this->appId = id;
}

// return other properties
qreal Weather::longitude()
{
    return this->m_longitude;
}
qreal Weather::latitude()
{
    return this->m_latitude;
}
qreal Weather::humidity()
{
    return this->m_humidity;
}
qreal Weather::wind()
{
    return this->m_wind;
}
qreal Weather::weatherId()
{
    return this->m_weatherId;
}
