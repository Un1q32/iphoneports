#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -# -o source.tar.gz https://www.openssl.org/source/openssl-1.1.1s.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv openssl-1.1.1s source
