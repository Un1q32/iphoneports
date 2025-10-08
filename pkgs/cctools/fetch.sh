#!/bin/sh
commit=b693954f5f86262e3e300b322e3264c210bc6262
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/Un1q32/cctools-port/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "cctools-port-${commit}" src
