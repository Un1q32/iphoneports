#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz/download
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv pcre-8.45 source
