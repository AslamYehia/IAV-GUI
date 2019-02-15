//#include "joycontroler.h"


//Need to implement new Joystick features with motor controller

//JoyControler::JoyControler(QObject *parent) : QObject(parent)
//{
//    this->m_detected = false;

//    Extreme3DProService& es = Extreme3DProService::GetInstance();

//    this->es.Initialize();
//    auto& a = this->es.GetIDs();
//    if (a.size() > 0)
//    {
//        this->id = a[0];
//        LogitechAxes(a[0], &this->es);
//        this->detected = true;
//    }
//}
//void LogitechAxes(int id, Extreme3DProService& es)
//{
//    int x, y, z, slider;
//    bool one, two, three, four, five, six, seven, eight, nine, ten, eleven;
//    JoystickLibrary::Extreme3DProButton Trigger, Button2 , Button3, Button4, Button5, Button6, Button7, Button8, Button9, Button10, Button11;

//    if (!es.GetX(id, x))
//        x = 0;
//    if (!es.GetY(id, y))
//        y = 0;
//    if (!es.GetZRot(id, z))
//        z = 0;
//    if (!es.GetSlider(id, slider))
//        slider = 0;
//    if (!es.GetButton(id,Trigger, one))
//       one = false;
//    if (!es.GetButton(id,Button2, two))
//       two = false;
//    if (!es.GetButton(id,Button3, three))
//       three = false;
//    if (!es.GetButton(id,Button4, four))
//       four = false;
//    if (!es.GetButton(id,Button5, five))
//       five = false;
//    if (!es.GetButton(id,Button6, six))
//       six = false;
//    if (!es.GetButton(id,Button7, seven))
//       seven = false;
//    if (!es.GetButton(id,Button8, eight))
//       eight = false;
//    if (!es.GetButton(id,Button9, nine))
//       nine = false;
//    if (!es.GetButton(id,Button10, ten))
//       ten = false;
//    if (!es.GetButton(id,Button11, eleven))
//       eleven = false;
//}

//void JoyControler::getPositions()
//{
//    this->es.GetX(this->id, this->m_posX));
//    this->es.GetY(this->id, this->m_posY);
//}
//bool JoyControler::detected()
//{
//    return this->detected;
//}
//qint8 JoyControler::posX()
//{
//    return this->m_posX;
//}
//qint8 JoyControler::posY()
//{
//    return this->m_posY;
//}
