#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.7.0.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv libressl-3.7.0 source
