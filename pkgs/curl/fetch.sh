#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/curl/curl/releases/download/curl-7_88_0/curl-7.88.0.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv curl-7.88.0 source
