#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='0.706'
if [ ! -f "$_DLCACHE/luau-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/luau-$ver.tar.gz" | awk '{print $1}')" != "f4968e32947f7aaf65ea66efe803918c539239f00d95eb329de7cea16573be3d" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/luau-$ver.tar.gz" "https://github.com/luau-lang/luau/archive/refs/tags/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/luau-$ver.tar.gz"
mv "$_TMP"/luau-* "$_SRCDIR"
