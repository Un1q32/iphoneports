#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://www.jedsoft.org/releases/most/most-5.2.0.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv most-5.2.0 source
