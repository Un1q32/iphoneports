#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/xyproto/tinyxxd/archive/refs/tags/v1.3.7.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv tinyxxd-* src
