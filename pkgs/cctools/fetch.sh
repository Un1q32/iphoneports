#!/bin/sh
commit=2db454bc8480b5450697da84f7727bb0924d61f6
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/tpoechtrager/cctools-port/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "cctools-port-${commit}" src
