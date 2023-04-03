#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://cfhcable.dl.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv pcre-8.45 source
