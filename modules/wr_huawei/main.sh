#!/bin/bash
OPENWBBASEDIR=$(cd `dirname $0`/../../ && pwd)
RAMDISKDIR="${OPENWBBASEDIR}/ramdisk"
MODULEDIR=$(cd `dirname $0` && pwd)
DMOD="PV"
#DMOD="MAIN"
Debug=$debug

#For development only
#Debug=1

if [ ${DMOD} == "MAIN" ]; then
        MYLOGFILE="${RAMDISKDIR}/openWB.log"
else
        MYLOGFILE="${RAMDISKDIR}/nurpv.log"
fi


python3 ${OPENWBBASEDIR}/packages/modules/huawei/device.py "${pv1_ipa}" "${pv1_ida}">>${MYLOGFILE} 2>&1

pvwatt=$(<${RAMDISKDIR}/pvwatt)
echo $pvwatt
