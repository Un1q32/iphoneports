#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://www.greenwoodsoftware.com/less/less-643.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv less-643 src
