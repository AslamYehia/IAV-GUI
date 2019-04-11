//#ifndef JOYSTICK_H
//#define JOYSTICK_H

//#include <QObject>
//#include "Extreme3DProService.hpp"
//#include "Xbox360Service.hpp"

//using JoystickLibrary::Extreme3DProService;
//using JoystickLibrary::Xbox360Service;


//class JoyControler : public QObject
//{
//    Q_PROPERTY(int posX READ posX NOTIFY posXChanged)
//    Q_PROPERTY(int posY READ posY NOTIFY posYChanged)
//    Q_PROPERTY(bool detected READ detected NOTIFY detectedChanged)
//    Q_PROPERTY(void name READ getPositions)
//    Q_OBJECT
//public:
//    explicit JoyControler(QObject *parent = nullptr);

//    Extreme3DProService& es = Extreme3DProService::GetInstance();
//    Xbox360Service& xs = Xbox360Service::GetInstance();

//    bool detected();
//    void getPositions();
//    int id;
//    int posX();
//    int posY();

//private:
//    int m_posX;
//    int m_posY;
//    bool m_detected;

//signals:

//    void onCoordinateChange();

//public slots:
//};

//#endif // JOYSTICK_H
