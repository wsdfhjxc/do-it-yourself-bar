#include "DoItYourselfBar.hpp"


DoItYourselfBar::DoItYourselfBar(QObject* parent) : QObject(parent),
        dbusService(parent) {

    QObject::connect(&dbusService, &DBusService::dataPassed,
                     this, &DoItYourselfBar::handlePassedData);
}

void DoItYourselfBar::handlePassedData(QString data) {
}
