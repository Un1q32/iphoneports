#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/nghttp2/nghttp2/releases/download/v1.55.1/nghttp2-1.55.1.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv nghttp2-1.55.1 src