#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://git.gavinhoward.com/gavin/bc/releases/download/6.7.4/bc-6.7.4.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv bc-6.7.4 src
