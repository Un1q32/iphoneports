#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/apple-oss-distributions/top/archive/refs/tags/top-39.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
mv top-top-39 src
rm src.tar.gz
