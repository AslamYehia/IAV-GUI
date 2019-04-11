#ifndef WEATHER_H
#define WEATHER_H


#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>

#include <QObject>
#include <QMap>
#include <QString>
#include <QJsonObject>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonArray>



/**
 * @brief The Weather class will get weather data based on the current location
 * using geolocation and both longitude and latitude of the current location. The weather
 * class gets weather info from openweathermap.org using it http request api.
 */

class Weather : public QObject
{
    Q_OBJECT

    // we define this properties so we can use them from inside qml aka the front end.
    Q_PROPERTY(QString weatherDescription READ weatherDescription NOTIFY weatherDescriptionChanged)
    Q_PROPERTY(QString cityName READ cityName NOTIFY cityNameChanged)
    Q_PROPERTY(qreal temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(QString appId WRITE setAppId )
    Q_PROPERTY(qreal longitude READ longitude NOTIFY longitudeChanged )
    Q_PROPERTY(qreal latitude READ latitude NOTIFY latitudeChanged)
    Q_PROPERTY(qreal humidity READ humidity NOTIFY humidityChanged)
    Q_PROPERTY(qreal wind READ wind NOTIFY windChanged)
    Q_PROPERTY(QString imgCode READ imgCode  NOTIFY imgCodeChanged)
    Q_PROPERTY(qreal weatherId READ weatherId NOTIFY weatherIdChanged)

public:
    explicit Weather(QObject *parent = nullptr, QString appid = nullptr );

    QMap<QString, double> getCoordinate();
    Q_INVOKABLE void getWeatherInfo();

    // geters for weather data, this are called in qml front end
    QString weatherDescription();
    QString cityName();
    QString imgCode();
    qreal temperature();
    qreal longitude();
    qreal latitude();
    qreal humidity();
    qreal wind();
    qreal weatherId();

    void setAppId(QString);

private:
    int counter;
    QString m_weatherDescription;
    QString m_cityName;
    QString m_imgCode;
    qreal m_temperature;
    qreal m_longitude;
    qreal m_latitude;
    qreal m_humidity;
    qreal m_wind;
    qreal m_weatherId;

    QString openMapUrl;
    QString appId;

signals:
    void weatherDescriptionChanged();
    void cityNameChanged();
    void temperatureChanged();
    void humidityChanged();
    void latitudeChanged();
    void longitudeChanged();
    void windChanged();
    void imgCodeChanged();
    void weatherIdChanged();

    void dataRead();

public slots:
};

#endif // WEATHER_H
