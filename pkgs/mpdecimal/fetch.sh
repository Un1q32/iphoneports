#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.0.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv mpdecimal-* src
