#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir -p "$_SRCDIR"
ver=1.9.4
curl -L -s -o "$_SRCDIR/pfetch" "https://raw.githubusercontent.com/Un1q32/pfetch/$ver/pfetch" &
curl -L -s -o "$_SRCDIR/LICENSE" "https://raw.githubusercontent.com/Un1q32/pfetch/$ver/LICENSE"
wait
chmod 755 "$_SRCDIR/pfetch"
