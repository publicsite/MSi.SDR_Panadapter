#!/bin/sh

OLD_UMASK="$(umask)"
umask 0022

#############INSTALL SOAPYMIRI DRIVER############

sudo apt-get install -y libsoapysdr-dev

git clone "https://github.com/ericek111/SoapyMiri"

cd SoapyMiri
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install

sudo cp libsoapyMiriSupport.so /usr/lib/x86_64-linux-gnu/SoapySDR/modules*/

cd ../../

echo "Package: soapymiri-dummy" > soapymiri-dummy.equivs
echo "Version: 1" >> soapymiri-dummy.equivs
echo "Provides: soapysdr-module-mirisdr (= 99.99), soapysdr0.8-module-mirisdr (= 99.99)" >> soapymiri-dummy.equivs
echo 'Maintainer: Nobody <nobody@nobody.com>' >> soapymiri-dummy.equivs
echo "Architecture: all" >> soapymiri-dummy.equivs
echo "Description: dummy package for installing SoapyMiri driver from git" >> soapymiri-dummy.equivs

equivs-build soapymiri-dummy.equivs

sudo apt-get autoremove -y soapysdr-module-mirisdr
sudo apt-get autoremove -y soapysdr0.8-module-mirisdr

sudo dpkg -i soapymiri-dummy_1_all.deb

sudo apt-get install -y gr-osmosdr libosmosdr0 libsoapysdr0.8 soapysdr0.8-module-all soapysdr-module-all

sudo apt-get install -y liblimesuite23.11-1 limesuite-udev soapyosmo-common0.8 soapysdr0.8-module-lms7 soapysdr0.8-module-osmosdr soapysdr0.8-module-rfspace

sudo apt-get install soapyremote-server

umask "${OLD_UMASK}"

