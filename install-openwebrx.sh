#!/bin/sh

#from https://github.com/jketterl/openwebrx/wiki/Manual-Package-installation-(including-digital-voice)

theuser="$(whoami)"

sudo apt-get update && \
sudo apt-get install git build-essential cmake libfftw3-dev python3 python3-setuptools rtl-sdr netcat-traditional libsndfile-dev librtlsdr-dev automake autoconf libtool pkg-config libsamplerate0-dev libpython3-dev

git clone -b master https://github.com/jketterl/csdr.git
cd csdr
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..
sudo ldconfig

git clone -b master https://github.com/jketterl/pycsdr.git
cd pycsdr
sudo python3 setup.py install install_headers
cd ..

git clone -b master https://github.com/jketterl/js8py.git
cd js8py
sudo python3 setup.py install
cd ..

#note we assume soapysdr is already installed

git clone -b master https://github.com/jketterl/owrx_connector.git
cd owrx_connector
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..
sudo ldconfig

sudo apt-get install sox libprotobuf-dev protobuf-compiler libudev-dev libicu-dev

git clone -b master https://github.com/jketterl/codecserver.git
cd codecserver
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..
sudo ldconfig

sudo adduser --system --group --no-create-home --home /nonexistent --quiet codecserver
sudo usermod -aG dialout codecserver

##sudo nano /usr/local/etc/codecserver/codecserver.conf
sudo systemctl daemon-reload
sudo systemctl restart codecserver

git clone -b master https://github.com/jketterl/digiham.git
cd digiham
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..

git clone -b master https://github.com/jketterl/pydigiham.git
cd pydigiham
sudo python3 setup.py install
cd ..

sudo apt-get install libcodec2-dev

sudo apt-get install libboost-program-options-dev
git clone https://github.com/mobilinkd/m17-cxx-demod.git
cd m17-cxx-demod
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..

sudo apt-get install qt5-qmake libpulse0 libfaad2 libopus0 libpulse-dev libfaad-dev libopus-dev libfftw3-dev wget
wget https://downloads.sourceforge.net/project/drm/dream/2.1/dream-2.1-svn742.src.tar.gz
tar xvfz dream-2.1-svn742.src.tar.gz
cd dream
qmake -qt=qt5 CONFIG+=console
make
sudo make install
cd ..

sudo apt-get install direwolf

sudo git clone https://github.com/hessu/aprs-symbols /usr/share/aprs-symbols

sudo apt-get install wsjtx

sudo mkdir /var/lib/openwebrx
sudo chown ${theuser}. /var/lib/openwebrx

sudo sh -c "echo [] > /var/lib/openwebrx/users.json"
sudo chown ${theuser}. /var/lib/openwebrx/users.json
sudo chmod 0600 /var/lib/openwebrx/users.json

git clone -b master https://github.com/jketterl/openwebrx.git
cd openwebrx

./openwebrx.py admin adduser ${theuser}

sudo mkdir /etc/openwebrx/
sudo cp bands.json /etc/openwebrx/

sudo systemctl enable openwebrx

sudo systemctl start openwebrx

mv htdocs/map.html htdocs/map.html.old
mv htdocs/map.js htdocs/map.js.old
mv htdocs/lib/AprsMarker.js htdocs/lib/AprsMarker.js.old
mv htdocs/lib/nite-overlay.js htdocs/lib/nite-overlay.js.old
mv htdocs/css/map.css htdocs/css/map.css.old
mv htdocs/css/bootstrap.min.css htdocs/css/bootstrap.min.css.old

wget https://raw.githubusercontent.com/dl9rdz/openwebrx/develop/htdocs/map.html -O htdocs/map.html
wget https://raw.githubusercontent.com/dl9rdz/openwebrx/develop/htdocs/map.js -O htdocs/map.js
wget https://raw.githubusercontent.com/dl9rdz/openwebrx/develop/htdocs/lib/AprsMarker.js -O htdocs/lib/AprsMarker.js
wget https://raw.githubusercontent.com/dl9rdz/openwebrx/develop/htdocs/lib/nite-overlay.js -O htdocs/lib/nite-overlay.js
wget https://raw.githubusercontent.com/dl9rdz/openwebrx/develop/htdocs/css/map.css -O htdocs/css/map.css
wget https://raw.githubusercontent.com/dl9rdz/openwebrx/develop/htdocs/css/bootstrap.min.css -O htdocs/css/bootstrap.min.css
