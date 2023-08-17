#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.7.3.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv libressl-3.7.3 src
