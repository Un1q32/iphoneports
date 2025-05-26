#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/ngtcp2/nghttp3/releases/download/v1.10.0/nghttp3-1.10.0.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv nghttp3-* src
