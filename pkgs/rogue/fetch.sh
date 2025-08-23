#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/Davidslv/rogue/archive/refs/tags/5.4.4.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv rogue-5.4.4 src
curl -L -s -o src/config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=a2287c3041a3f2a204eb942e09c015eab00dc7dd' &
curl -L -s -o src/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=a2287c3041a3f2a204eb942e09c015eab00dc7dd'
wait
