#!/bin/bash
OPENWBBASEDIR=$(cd "$(dirname $0)"/../../ && pwd)
RAMDISKDIR="${OPENWBBASEDIR}/ramdisk"
#DMOD="EVU"
DMOD="MAIN"

if [ ${DMOD} == "MAIN" ]; then
	MYLOGFILE="${RAMDISKDIR}/openWB.log"
else
	MYLOGFILE="${RAMDISKDIR}/evu.log"
fi

# check if config file is already in env
if [[ -z "$debug" ]]; then
	echo "bezug_fronius_s0: Seems like openwb.conf is not loaded. Reading file."
	# try to load config
	. $OPENWBBASEDIR/loadconfig.sh
	# load helperFunctions
	. $OPENWBBASEDIR/helperFunctions.sh
fi

openwbDebugLog ${DMOD} 2 "WR IP: ${wrfroniusip}"
openwbDebugLog ${DMOD} 2 "WR Erzeugung: ${froniuserzeugung}"
openwbDebugLog ${DMOD} 2 "WR GEN24: ${wrfroniusisgen24}"
openwbDebugLog ${DMOD} 2 "WR Var2: ${froniusvar2}"
openwbDebugLog ${DMOD} 2 "WR MeterLocation: ${froniusmeterlocation}"
openwbDebugLog ${DMOD} 2 "WR IP2: ${wrfronius2ip}"
openwbDebugLog ${DMOD} 2 "WR Speicher: ${speichermodul}"

bash "$OPENWBBASEDIR/packages/legacy_run.sh" "modules.fronius.device" "counter_s0" "${wrfroniusip}" "${froniuserzeugung}" "${wrfroniusisgen24}" "${froniusvar2}" "${froniusmeterlocation}" "${wrfronius2ip}" "${speichermodul}" 2>>$MYLOGFILE

wattbezug=$(<${RAMDISKDIR}/wattbezug)
echo $wattbezug
