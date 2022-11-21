#!/bin/sh
SoapySDRServer --bind=127.0.0.1:55132
cd openwebrx
./openwebrx.py

#then go to http://localhost:8073/