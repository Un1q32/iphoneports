#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://git.gavinhoward.com/gavin/bc/releases/download/7.0.2/bc-7.0.2.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv bc-7.0.2 src
