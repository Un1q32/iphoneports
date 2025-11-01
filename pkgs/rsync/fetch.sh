#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://download.samba.org/pub/rsync/src/rsync-3.4.1.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv rsync-* "$_SRCDIR"
