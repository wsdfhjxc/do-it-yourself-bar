#pragma once

#include <QString>
#include <QVariantMap>

class BlockInfo {
public:
    QString style;
    QString labelText;
    QString tooltipText;
    QString commandToExecOnClick;

    QVariantMap toQVariantMap();
};
