#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://github.com/apple-oss-distributions/xar/archive/refs/tags/xar-501.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv xar-xar-* "$_SRCDIR"
curl -L -s -o src/xar/config.guess https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.guess &
curl -L -s -o src/xar/config.sub https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.sub
wait
