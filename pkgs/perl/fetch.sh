#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.42.0'
if [ ! -f "$_DLCACHE/perl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/perl-$ver.tar.gz" | awk '{print $1}')" != "e2bb05cea46921009b7902b927b58110949c4f8e51b0583f57e3e1eeff5306d8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/perl-$ver.tar.gz" "https://github.com/Perl/perl5/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
crossver='1.6.4'
if [ ! -f "$_DLCACHE/perl-cross-$crossver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/perl-cross-$crossver.tar.gz" | awk '{print $1}')" != "b176522bceb1fc3533eb85e4435e5ab06f7473633979122a8f5b18a2b4fc865a" ]; then
    curl -L -# -o "$_DLCACHE/perl-cross-$crossver.tar.gz" "https://github.com/arsv/perl-cross/archive/refs/tags/$crossver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/perl-$ver.tar.gz"
mv "$_TMP"/perl* "$_SRCDIR"
tar -C "$_SRCDIR" -xf "$_DLCACHE/perl-cross-$crossver.tar.gz"
cp -a "$_SRCDIR/perl-cross-$crossver"/* "$_SRCDIR"
rm -rf "$_SRCDIR/perl-cross-$crossver"
