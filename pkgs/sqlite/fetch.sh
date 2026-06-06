#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='3530200'
if [ ! -f "$_DLCACHE/sqlite-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/sqlite-$ver.tar.gz" | awk '{print $1}')" != "588ad51949419a56ebe81fe56193d510c559eb94c9a57748387860b5d3069316" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/sqlite-$ver.tar.gz" "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/sqlite-$ver.tar.gz"
mv "$_TMP"/sqlite-* "$_SRCDIR"
