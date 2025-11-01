#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-0.5.12.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv dash-0.5.12 "$_SRCDIR"
