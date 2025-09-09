#!/bin/sh -e
commit=cef9e97fec59c5e09ec37646168cfd1cf57fd24b
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/Un1q32/apt-cydia/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "apt-cydia-${commit}" src
mkdir src/iphoneports-bin
curl -L -s -o src/iphoneports-bin/triehash https://raw.githubusercontent.com/julian-klode/triehash/refs/tags/debian/0.3-3/triehash.pl
chmod +x src/iphoneports-bin/triehash
