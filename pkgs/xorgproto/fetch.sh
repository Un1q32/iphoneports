#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2024.1.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv xorgproto-* src
