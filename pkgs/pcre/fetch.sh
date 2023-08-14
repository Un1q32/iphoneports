#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://cfhcable.dl.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv pcre-8.45 src
