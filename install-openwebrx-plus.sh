#!/bin/sh

OLD_UMASK="$(umask)"
umask 0022

git clone https://github.com/luarvique/openwebrx.git
cd openwebrx

sudo apt-get install -y libsamplerate0-dev dh-python python3-all python3-setuptools \
librtlsdr-dev libprotobuf-dev protobuf-compiler libudev-dev \
meson libsndfile1-dev libliquid-dev nlohmann-json3-dev intltool python3-distutils-extra

#we use non-proprietary, free and open source software ie. not this:
sed -i "s#\tBUILD_SOAPYSDRPLAY3=y#\tBUILD_SOAPYSDRPLAY3=n#g" buildall.sh

#this doesn't seem to build, so we omit it, unfortunately:
sed -i "s#\tBUILD_DIGIHAM=y#\tBUILD_DIGIHAM=n#g" buildall.sh

#we don't have the libdigiham-dev package, so this doesn't build, and we omit it:
sed -i "s#\tBUILD_PYDIGIHAM=y#\tBUILD_PYDIGIHAM=n#g" buildall.sh

./buildall.sh

sudo dpkg -i ./owrx-output/*/*.deb

mkdir $HOME/openwebrx

#use a config file in $HOME/openwebrx instead of /var/lib/openwebrx (which cannot be written to)
sudo sed -i "s#/var/lib/openwebrx#$HOME/openwebrx#g" /etc/openwebrx/openwebrx.conf

openwebrx admin adduser administrator

cp -a settings.json $HOME/openwebrx/

umask "${OLD_UMASK}"
