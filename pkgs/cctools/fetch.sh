#!/bin/sh
commit=5346a44391162e37e294b610464cdb585d451205
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/Un1q32/cctools-port/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "cctools-port-${commit}" src
