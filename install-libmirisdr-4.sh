#!/bin/sh
thisuser="$(whoami)"
TARGET="x86_64-linux-gnu"
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install git cmake libusb-1.0-0-dev libusb-1.0-0
sudo ln -s /usr/lib/${TARGET}/libusb-1.0.so.0 /usr/lib/${TARGET}/libusb-1.0.so
git clone https://github.com/f4exb/libmirisdr-4
cd libmirisdr-4
sed -i "s#cmake#cmake -DCMAKE_INSTALL_PREFIX=/usr#g" build.sh
./build.sh

sudo apt-get autoremove libmirisdr0 libmirisdr-dev

cd build

sudo make install

sudo ln -s /usr/lib/libmirisdr.so /usr/lib/libmirisdr.so.0

cd ../../

sudo apt-get install equivs

echo "Package: libmirisdr-dummy" > libmirisdr-dummy.equivs
echo "Version: 1" >> libmirisdr-dummy.equivs
echo "Provides: libmirisdr0 (= 99.99), libmirisdr-dev (= 99.99)" >> libmirisdr-dummy.equivs
echo 'Maintainer: Nobody <nobody@nobody.com>' >> libmirisdr-dummy.equivs
echo "Architecture: all" >> libmirisdr-dummy.equivs
echo "Description: dummy libmirisdr package for installing libmirisdr-4 from git" >> libmirisdr-dummy.equivs

equivs-build libmirisdr-dummy.equivs

sudo dpkg -i libmirisdr-dummy_1.0_all.deb

echo "blacklist sdr_msi3101" | sudo tee /etc/modprobe.d/msisdr.blacklist.conf
echo "blacklist msi001" | sudo tee -a /etc/modprobe.d/msisdr.blacklist.conf
echo "blacklist msi2500" | sudo tee -a /etc/modprobe.d/msisdr.blacklist.conf

sudo apt-get install gr-osmosdr libosmosdr0 libsoapysdr0.8 soapysdr0.8-module-all soapysdr-module-mirisdr soapysdr-module-all

echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1df7\", ATTRS{idProduct}==\"2500\", OWNER=\"$thisuser\", GROUP=\"plugdev\", TAG+=\"uaccess\"" | sudo tee /etc/udev/rules.d/99-msisdr.rules

echo "MSI.SDR installed, please reboot your system."