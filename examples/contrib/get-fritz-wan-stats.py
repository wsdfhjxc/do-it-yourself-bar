#!/usr/bin/python

# Prerequisites:
# - Have a FRITZ!Box Internet router that is reachable at the address http://fritz.box
# - Add a user + password to your FRITZ!Box (via the web interface)
# - Run `pip install fritzconnection` to get the handy Python module by Klaus Bremer
#   (see https://fritzconnection.readthedocs.io)

import os, sys, time
from dbus import SessionBus
from fritzconnection.lib.fritzstatus import FritzStatus

os.environ['FRITZ_USERNAME'] = 'scriptuser'
os.environ['FRITZ_PASSWORD'] = 'the_password'

if len(sys.argv) == 1:
    print("No DIY bar ID given!")
    quit()

fc = None
while not fc:
    try:
        fc = FritzStatus(address='fritz.box')
    except:
        data = '| A | FRITZ!Box not reachable | Have you changed username and password in get-fritz-wan-stats.py? Is your network up? | |'
        os.system('/usr/bin/qdbus org.kde.plasma.doityourselfbar /id_' + sys.argv[1] + ' org.kde.plasma.doityourselfbar.pass \'' + data + '\'')
        pass
    time.sleep(5)

diy = SessionBus().get_object("org.kde.plasma.doityourselfbar","/id_" + sys.argv[1])
diy = getattr(diy, 'pass')

while fc:
    data = '| A | FRITZ!Box conn. up: ' + fc.str_uptime + ' | External IP: ' + fc.external_ip + ' | xdg-open http://fritz.box |'
    data += '| B | WAN Download: ' + fc.str_transmission_rate[1] + '/s | FRITZ!Box WAN Download | |'
    data += '| C | WAN Upload: ' + fc.str_transmission_rate[0] + '/s | FRITZ!Box WAN Upload | |'
    diy(data)
    time.sleep(5)
