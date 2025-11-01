#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='6.2.1'
if [ ! -f "$_DLCACHE/ctags-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/ctags-$ver.tar.gz" | awk '{print $1}')" != "2c63efe9e0e083dc50e6fdd8c5414781cc8873d8c8940cf553c01870ed962f8c" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/ctags-$ver.tar.gz" "https://github.com/universal-ctags/ctags/releases/download/v$ver/universal-ctags-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/ctags-$ver.tar.gz"
mv universal-ctags-* "$_SRCDIR"
