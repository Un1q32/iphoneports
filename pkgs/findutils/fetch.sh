#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv findutils-4.9.0 src
