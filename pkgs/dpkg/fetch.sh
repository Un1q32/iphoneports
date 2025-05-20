#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
dpkgver='1.22.18'
curl -L -# -o src.tar.bz2 "https://salsa.debian.org/dpkg-team/dpkg/-/archive/$dpkgver/dpkg-$dpkgver.tar.bz2"
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv dpkg-* src
printf '%s\n' "$dpkgver" > src/.dist-version
