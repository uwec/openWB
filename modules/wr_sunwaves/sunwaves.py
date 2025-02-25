#!/usr/bin/env python3
from datetime import datetime, timezone
import os
import re
import requests
from requests.auth import HTTPDigestAuth
import sys

Debug = int(os.environ.get('debug'))
myPid = str(os.getpid())

wrsunwavesip = str(sys.argv[1])
wrsunwavespw = str(sys.argv[2])


def DebugLog(message):
    local_time = datetime.now(timezone.utc).astimezone()
    print(local_time.strftime(format="%Y-%m-%d %H:%M:%S") + ": PID: " + myPid + ": " + message)


if Debug >= 2:
    DebugLog('PV Sunwaves IP:' + wrsunwavesip)
    DebugLog('PV Sunwaves Passwort:' + wrsunwavespw)


params = (('CAN', '1'),)
variable = requests.get("http://"+wrsunwavesip+"/data/ajax.txt", params=params, auth=HTTPDigestAuth("customer", wrsunwavespw))
variable.encoding = 'utf-8'
variable = variable.text.replace("\n", "")

count = 0

for v in variable:
    if count == 1:
        pvwatt = re.search('^[0-9]+$', v).group()
        pvwatt = pvwatt*-1
        if Debug >= 1:
            DebugLog('WR Leistung: ' + str(pvwatt))
        with open("/var/www/html/openWB/ramdisk/pvwatt", "w") as f:
            f.write(str(pvwatt))
    if count == 16:
        if Debug >= 1:
            DebugLog('WR Energie: ' + str(v*1000))
        with open("/var/www/html/openWB/ramdisk/pvkwh", "w") as f:
            f.write(str(v*1000))
    count = count+1

exit(0)
