#! /bin/bash

# declare global variable
log_file=/var/log/spa_log
network_file=/etc/network/interfaces
ssid=SuningRnD
ssid_password=Jx8bn2Kjz

echo "[SPA] Starting network_update.sh" >> $log_file

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

echo "[SPA] Restarting network interface..." >> $log_file
#sudo /etc/init.d/networking restart

ifdown wlan0
ifup wlan0

ifdown wlan1
ifup wlan1

sudo /etc/init.d/hostapd restart
sudo /etc/init.d/isc-dhcp-server restart
echo "[SPA] Done restarting..." >> $log_file
