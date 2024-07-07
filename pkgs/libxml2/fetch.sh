#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.2.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv libxml2-2.13.2 src
