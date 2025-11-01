#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -s -o "$_SRCDIR/2048.c" https://raw.githubusercontent.com/mevdschee/2048.c/refs/tags/v1.0.3/2048.c &
curl -L -s -o "$_SRCDIR/LICENSE" https://raw.githubusercontent.com/mevdschee/2048.c/refs/tags/v1.0.3/LICENSE
wait
