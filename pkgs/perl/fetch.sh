#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.42.0'
if [ ! -f "$_DLCACHE/perl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/perl-$ver.tar.gz" | awk '{print $1}')" != "e2bb05cea46921009b7902b927b58110949c4f8e51b0583f57e3e1eeff5306d8" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/perl-$ver.tar.gz" "https://github.com/Perl/perl5/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
crossver='add39339ed09334e6809b48b3f8474c01a7ea1a1'
if [ ! -f "$_DLCACHE/perl-cross-$crossver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/perl-cross-$crossver.tar.gz" | awk '{print $1}')" != "da3ddc6a81e0e7e5db9463dfb26e97a009a7117d5a8d42784de86ee2e0277f59" ]; then
    curl -L -# -o "$_DLCACHE/perl-cross-$crossver.tar.gz" "https://github.com/qnx-ports/perl-cross/archive/$crossver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/perl-$ver.tar.gz"
mv "$_TMP"/perl* "$_SRCDIR"
tar -C "$_SRCDIR" -xf "$_DLCACHE/perl-cross-$crossver.tar.gz"
cp -a "$_SRCDIR/perl-cross-$crossver"/* "$_SRCDIR"
rm -rf "$_SRCDIR/perl-cross-$crossver"
