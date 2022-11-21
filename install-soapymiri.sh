#!/bin/sh

git clone https://github.com/ericek111/SoapyMiri

cd SoapyMiri

sed -i "s#mirisdr_open(\&dev,#mirisdr_open(\&dev,MIRISDR_HW_SDRPLAY,#g" Settings.cpp

mkdir build

cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..

make

sudo cp libsoapyMiriSupport.so /usr/lib/x86_64-linux-gnu/SoapySDR/modules*/