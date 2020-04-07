#!/bin/bash
#
# installation script for iem-rx receiver

## hostname config
# change hostname and write it to /etc/hosts file
sudo hostnamectl set-hostname iem-rx
sudo sed -i 's/realtimepi/iem-rx/' /etc/hosts

## overlay config
# configure overlay by appending to /boot/config.txt file
echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
# disable internal soundcard by not loading its module
sed -i 's/dtparam=audio=on/dtparam=audio=off/' /boot/config.txt

## boot config
# disable sdhci low-latency mode by kernel cmdline
sudo sed -i 's/$/ sdhci_bcm2708.enable_llm=0/' /boot/cmdline.txt

## package installation
# change debconf default value for jackd1 package
echo jackd jackd/tweak_rt_limits boolean true | sudo debconf-set-selections
# install jack without recommendations and omitting install confirmation
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --option Dpkg::Options::="--force-confdef" --yes jackd1
# install zita-njbridge omitting install confirmation
sudo apt-get install --yes zita-njbridge

# append swappiness and inotify config to /etc/sysctl.conf and reread file
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -f /etc/sysctl.conf

## service configuration
# disable daemons not needed
sudo systemctl disable bluetooth.service
sudo systemctl disable hciuart
sudo systemctl disable dbus.service
sudo systemctl disable triggerhappy.service
# and mask them to be sure
sudo systemctl mask bluetooth.service
sudo systemctl mask hciuart
sudo systemctl mask dbus.service
sudo systemctl mask triggerhappy.service
# disable realtimepi's usage tracking
sudo systemctl disable usage-statistics.service

## wlan config
# overwrite helper file in /boot
cp conf/realtimepi-wpa-supplicant.txt /boot/realtimepi-wpa-supplicant.txt

## runtime setup
# create bin directory and copy prototype scripts
mkdir ~/bin
cp bin/rx-wlan.sh ~/bin/rx-wlan

exit 0

