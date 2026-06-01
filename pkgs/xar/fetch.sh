#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='501'
if [ ! -f "$_DLCACHE/xar-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/xar-$ver.tar.gz" | awk '{print $1}')" != "a83aa4984467bfecad6938b3659e71cc56d1a360a36bb8cd9025f276d6a27eda" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/xar-$ver.tar.gz" "https://github.com/apple-oss-distributions/xar/archive/refs/tags/xar-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/xar-$ver.tar.gz"
mv "$_TMP"/xar-* "$_SRCDIR"
cp "$_BSROOT/files/gnu-config/"* "$_SRCDIR"
