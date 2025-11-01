#!/bin/sh
commit=ef330422ef001ef2aa5792f4c6970d69f3c1f478
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/ProcursusTeam/ldid/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.gz
rm src.tar.gz
mv "$_TMP"/"ldid-${commit}" "$_SRCDIR"
