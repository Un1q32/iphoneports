#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/Davidslv/rogue/archive/refs/tags/5.4.4.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv rogue-5.4.4 src
curl -L -s -o src/config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=00b15927496058d23e6258a28d8996f87cf1f191' &
curl -L -s -o src/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=00b15927496058d23e6258a28d8996f87cf1f191'
wait
