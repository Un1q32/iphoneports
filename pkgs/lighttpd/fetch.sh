#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.73.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv lighttpd-1.4.73 src
