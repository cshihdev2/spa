#! /bin/bash

# declare global variable
log_file=/var/log/spa_trigger_log
ssid=SuningRnD
ssid_password=Jx8bn2Kjz

echo "[SPA-Trigger] Starting trigger_network_update.sh" >> $log_file

# reading command line
if [ $# -eq 2 ]; then
	echo "[SPA-Trigger] command line contains 2 arguments, set SSID and password according to the value $1 and $2" >> $log_file
	ssid=$1
	ssid_password=$2
else
	echo "[SPA-Trigger] command line contains $# argument, abort " >> $log_file
	echo "[SPA-Trigger] Exit 1 " >> $log_file
	exit 1
fi

echo "Running network_update.sh with $ssid, $ssid_password" >> $log_file
/home/pi/code/scripts/network_update.sh $ssid $ssid_password >> $log_file

echo "[SPA-Trigger] Exit 0 " >> $log_file
exit 0
