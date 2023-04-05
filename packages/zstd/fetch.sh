#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv zstd-1.5.5 source
