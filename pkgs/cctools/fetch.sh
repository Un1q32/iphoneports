#!/bin/sh
commit=164f42296d56fd9456cb9e969ad6cf95e430cb39
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/tpoechtrager/cctools-port/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "cctools-port-${commit}" src
