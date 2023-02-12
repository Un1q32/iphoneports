#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://pilotfiber.dl.sourceforge.net/project/libpng/libpng16/1.6.39/libpng-1.6.39.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv libpng-1.6.39 source
