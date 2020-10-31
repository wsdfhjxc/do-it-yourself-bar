#include "BlockInfo.hpp"

QVariantMap BlockInfo::toQVariantMap() {
    QVariantMap map;
    map.insert("style", style);
    map.insert("labelText", labelText);
    map.insert("tooltipText", tooltipText);
    map.insert("commandToExecOnClick", commandToExecOnClick);
    return map;
}
