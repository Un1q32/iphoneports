#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://snapshot.debian.org/file/295059bda18995efe34f22bc50befd574067bc70/dpkg_1.22.15.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv dpkg-* src
