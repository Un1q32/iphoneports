#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.4.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv dos2unix-7.4.4 source
