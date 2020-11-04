#include "DoItYourselfBar.hpp"

#include <QDBusConnection>
#include <QDebug>

#include "BlockInfo.hpp"

DoItYourselfBar::DoItYourselfBar(QObject* parent) :
        QObject(parent),
        dbusService(parent),
        dbusInstanceId(0),
        cfg_DBusInstanceId(0) {

    QObject::connect(&dbusService, &DBusService::dataPassed,
                     this, &DoItYourselfBar::handlePassedData);
}

void DoItYourselfBar::runCommand(QString command) {
    if (!command.isEmpty()) {
        system(QString("(" + command + ") &").toStdString().c_str());
    }
}

void DoItYourselfBar::cfg_DBusInstanceIdChanged() {
    auto sessionBus = QDBusConnection::sessionBus();
    sessionBus.registerService(SERVICE_NAME);

    if (dbusInstanceId != 0) {
        QString path = "/id_" + QString::number(dbusInstanceId);
        sessionBus.unregisterObject(path, QDBusConnection::UnregisterTree);
    }

    bool dbusSuccess = false;

    if (cfg_DBusInstanceId != 0) {
        QString path = "/id_" + QString::number(cfg_DBusInstanceId);
        if (sessionBus.registerObject(path, QString(SERVICE_NAME),
                                      &dbusService, QDBusConnection::ExportAllSlots)) {
            dbusSuccess = true;
            dbusInstanceId = cfg_DBusInstanceId;
        }
    }

    emit dbusSuccessChanged(dbusSuccess);
}

void DoItYourselfBar::handlePassedData(QString data) {
    QVariantList blockInfoList;

    BlockInfo blockInfo;
    int separatorCount = !data.isEmpty() ? 0 : -1;

    for (int i = 0; i < data.length(); i++) {
        QChar character = data.at(i);

        bool isEscapingCharacter = character == QChar('\\') &&
                                   i < data.length() - 1 &&
                                   data.at(i + 1) == QChar('|');
        if (isEscapingCharacter) {
            continue;
        }

        bool isSeparatorCharacter = character == QChar('|') &&
                                    (i == 0 || data.at(i - 1) != QChar('\\'));
        if (isSeparatorCharacter) {
            separatorCount++;

            if (separatorCount % 5 == 0) {
                blockInfo.style = blockInfo.style.trimmed();
                blockInfo.labelText = blockInfo.labelText.trimmed();
                blockInfo.tooltipText = blockInfo.tooltipText.trimmed();
                blockInfo.commandToExecOnClick = blockInfo.commandToExecOnClick.trimmed();

                blockInfoList << blockInfo.toQVariantMap();
                blockInfo = BlockInfo();
            }

            continue;
        }

        if (separatorCount % 5 == 1) {
            blockInfo.style += character;
        } else if (separatorCount % 5 == 2) {
            blockInfo.labelText += character;
        } else if (separatorCount % 5 == 3) {
            blockInfo.tooltipText += character;
        } else if (separatorCount % 5 == 4) {
            blockInfo.commandToExecOnClick += character;
        } else {
            separatorCount = -1;
            break;
        }
    }

    if (separatorCount % 5 != 0) {
        emit invalidDataFormatDetected();
    } else {
        emit blockInfoListSent(blockInfoList);
    }
}
