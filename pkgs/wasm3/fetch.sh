#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='79d412ea5fcf92f0efe658d52827a0e0a96ff442'
[ -z "$_DLCACHE" ] && _DLCACHE=/tmp
if [ ! -f "$_DLCACHE/wasm3-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/wasm3-$ver.tar.gz" | awk '{print $1}')" != "adc76b13fc4d2192428dbe7f18617e94a7b3e464b0ae65f282ad50ac1c5f5088" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/wasm3-$ver.tar.gz" "https://github.com/wasm3/wasm3/archive/$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -xf "$_DLCACHE/wasm3-$ver.tar.gz"
mv wasm3-* "$_SRCDIR"
