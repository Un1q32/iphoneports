#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
dpkgver='1.22.21'
curl -L -# -o src.tar.bz2 "https://salsa.debian.org/dpkg-team/dpkg/-/archive/$dpkgver/dpkg-$dpkgver.tar.bz2"
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv dpkg-* "$_SRCDIR"
printf '%s\n' "$dpkgver" > "$_SRCDIR/.dist-version"
