#pragma once

#include <QObject>

#include "DBusService.hpp"

class DoItYourselfBar : public QObject {
    Q_OBJECT

public:
    DoItYourselfBar(QObject* parent = nullptr);

private:
    DBusService dbusService;

    void handlePassedData(QString data);
};
