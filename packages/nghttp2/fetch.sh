#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://github.com/nghttp2/nghttp2/releases/download/v1.54.0/nghttp2-1.54.0.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv nghttp2-1.54.0 source
