#!/bin/sh
commit=ec7999a748f2ce167a36756f11df0c5d8101170e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -# -o "$_SRCDIR/pstree.c" "https://raw.githubusercontent.com/FredHucht/pstree/$commit/pstree.c" &
curl -# -o "$_SRCDIR/LICENSE" "https://raw.githubusercontent.com/FredHucht/pstree/$commit/LICENSE"
wait
