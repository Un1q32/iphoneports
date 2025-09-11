#!/bin/sh -e
ver=3.1.5
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://salsa.debian.org/apt-team/apt/-/archive/$ver/apt-$ver.tar.bz2"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv apt-* src
mkdir src/iphoneports-bin
curl -L -s -o src/iphoneports-bin/triehash https://raw.githubusercontent.com/julian-klode/triehash/refs/tags/debian/0.3-3/triehash.pl
chmod +x src/iphoneports-bin/triehash
