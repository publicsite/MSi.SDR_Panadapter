#!/bin/sh

OLD_UMASK="$(umask)"
umask 0022

thisuser="$(whoami)"
TARGET="x86_64-linux-gnu"
sudo apt-get update && sudo apt-get upgrade -y

############INSTALL LIBMIRISDR##################

sudo apt-get install -y build-essential git cmake libusb-1.0-0-dev libusb-1.0-0
sudo ln -s /usr/lib/${TARGET}/libusb-1.0.so.0 /usr/lib/${TARGET}/libusb-1.0.so
git clone https://github.com/ericek111/libmirisdr-5
cd libmirisdr-5

sudo apt-get autoremove -y libmirisdr0
sudo apt-get autoremove -y libmirisdr4
sudo apt-get autoremove -y libmirisdr-dev

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..

make

sudo make install

sudo ln -s /usr/lib/libmirisdr.so /usr/lib/libmirisdr.so.0

cd ../../

sudo apt-get install -y equivs

echo "Package: libmirisdr-dummy" > libmirisdr-dummy.equivs
echo "Version: 1" >> libmirisdr-dummy.equivs
echo "Provides: libmirisdr0 (= 99.99), libmirisdr4 (= 99.99), libmirisdr-dev (= 99.99)" >> libmirisdr-dummy.equivs
echo 'Maintainer: Nobody <nobody@nobody.com>' >> libmirisdr-dummy.equivs
echo "Architecture: all" >> libmirisdr-dummy.equivs
echo "Description: dummy libmirisdr package for installing libmirisdr-5 from git" >> libmirisdr-dummy.equivs

equivs-build libmirisdr-dummy.equivs

sudo dpkg -i libmirisdr-dummy_1_all.deb

if [ ! -f /etc/modprobe.d/msisdr.blacklist.conf ]; then
	echo "Blacklisting kernel driver so we can get it running as an SDR..."

	echo "blacklist sdr_msi3101" | sudo tee /etc/modprobe.d/msisdr.blacklist.conf
	echo "blacklist msi001" | sudo tee -a /etc/modprobe.d/msisdr.blacklist.conf
	echo "blacklist msi2500" | sudo tee -a /etc/modprobe.d/msisdr.blacklist.conf
else
	echo "Kernel driver already blacklisted, we shant do it twice."
fi

if [ ! -f /etc/udev/rules.d/99-msisdr.rules ]; then
	echo "Adding udev rule."
	echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1df7\", ATTRS{idProduct}==\"2500\", OWNER=\"$thisuser\", GROUP=\"plugdev\", TAG+=\"uaccess\"" | sudo tee /etc/udev/rules.d/99-msisdr.rules
else
	echo "Udev rule already added, we shant do it twice."
fi

echo "MSI.SDR installed, please reboot your system."

umask "${OLD_UMASK}"
