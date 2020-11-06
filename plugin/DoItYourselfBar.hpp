#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>

#include "DBusService.hpp"

class DoItYourselfBar : public QObject {
    Q_OBJECT

public:
    DoItYourselfBar(QObject* parent = nullptr);
    ~DoItYourselfBar();

    Q_INVOKABLE void runStartupScript();
    Q_INVOKABLE void runCommand(QString command);

    Q_PROPERTY(unsigned cfg_DBusInstanceId
               MEMBER cfg_DBusInstanceId
               NOTIFY cfg_DBusInstanceIdChanged)

    Q_PROPERTY(QString cfg_StartupScriptPath
               MEMBER cfg_StartupScriptPath)

    void cfg_DBusInstanceIdChanged();

signals:
    void dbusSuccessChanged(bool dbusSuccess);
    void invalidDataFormatDetected();
    void blockInfoListSent(QVariantList blockInfoList);

private:
    pid_t childPid;

    DBusService dbusService;
    unsigned dbusInstanceId;
    bool registerDBusService();

    unsigned cfg_DBusInstanceId;
    QString cfg_StartupScriptPath;

    void handlePassedData(QString data);
};
