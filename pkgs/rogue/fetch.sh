#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/Davidslv/rogue/archive/refs/tags/5.4.4.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv rogue-* "$_SRCDIR"
curl -L -s -o src/config.guess https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.guess &
curl -L -s -o src/config.sub https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.sub
wait
