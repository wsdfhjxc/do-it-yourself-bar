#!/usr/bin/python

# Prerequisites:
# - Have a FRITZ!Box Internet router that is reachable at the address http://fritz.box
# - Add a user + password to your FRITZ!Box (via the web interface)
# - Run `pip install fritzconnection` to get the handy Python module by Klaus Bremer
#   (see https://fritzconnection.readthedocs.io)

import os, sys, time
from fritzconnection.lib.fritzstatus import FritzStatus

os.environ['FRITZ_USERNAME'] = 'scriptuser'
os.environ['FRITZ_PASSWORD'] = 'the_password'

fc = FritzStatus(address='fritz.box')
while True:
    data = '| A | FRITZ!Box conn. up: ' + fc.str_uptime + ' | External IP: ' + fc.external_ip + ' | xdg-open http://fritz.box |'
    data += '| B | WAN Download: ' + fc.str_transmission_rate[1] + '/s | FRITZ!Box WAN Download | |'
    data += '| C | WAN Upload: ' + fc.str_transmission_rate[0] + '/s | FRITZ!Box WAN Upload | |'
    os.system('/usr/bin/qdbus org.kde.plasma.doityourselfbar /id_' + sys.argv[1] + ' org.kde.plasma.doityourselfbar.pass \'' + data + '\'')
    time.sleep(5)
