#! /bin/bash

# declare global variable
log_file=/var/log/spa_log
network_file=/etc/network/interfaces
ssid=SuningRnD
ssid_password=Jx8bn2Kjz
is_ssid_up=1

echo "[SPA] Starting network_update.sh" >> $log_file

# reading command line
if [ $# -eq 2 ]; then
	echo "[SPA] command line contains 2 arguments, set SSID and password according to the value $1 and $2" >> $log_file
	ssid=$1
	ssid_password=$2
elif [ $# -eq 0 ]; then
	echo "[SPA] command line contains no argument, set default value" >> $log_file
else
	echo "[SPA] command line contains $# argument, abort " >> $log_file
	echo "Usage: network_update.sh [SSID] [Password]" 
fi



################### functions #####################

function restart_interface {

echo "[SPA] Restarting network interface..." >> $log_file

ifdown wlan0
ifup wlan0

#ifdown wlan1
#ifup wlan1

#sudo /etc/init.d/hostapd restart
#sudo /etc/init.d/isc-dhcp-server restart

echo "[SPA] Done restarting..." >> $log_file

}

function check_ssid_up {
	echo "[SPA] Checking if the network is up for SSID=$1..." >> $log_file
	if [ `iwgetid -r | grep $1 | wc -l` -eq 1 ]; then
		echo "[SPA] test condition is true" >> $log_file
		is_ssid_up=0
	else
		echo "[SPA] test condition is false" >> $log_file
	fi
}
###################################################

#backup interface file
current_ts=`date +%Y%m%d_%M%S`
backup_file=$network_file'_bk_'$current_ts
echo "[SPA] Backup current network interfaces -> $backup_file" >> $log_file
cp $network_file $backup_file 

echo ">>>>>>> Origin File >>>>>>> "
cat $network_file
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<"


new_ssid="wpa-ssid \"$ssid\""
new_password="wpa-psk \"$ssid_password\""

#echo $new_ssid
#echo $new_password

sed -i "s/^wpa-ssid.*/$new_ssid/" $network_file
sed -i "s/^wpa-psk.*/$new_password/" $network_file

echo ">>>>>>>> New File >>>>>>>>> "
cat $network_file
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<"

restart_interface
check_ssid_up $ssid

if [ $is_ssid_up -eq 0 ]; then
	echo "[SPA] $ssid connection is successful" >> $log_file
else
	echo "[SPA] $ssid connection failed" >> $log_file
fi

echo "[SPA] Script complete ... " >> $log_file
