#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='5.44.0'
if [ ! -f "$_DLCACHE/perl-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/perl-$ver.tar.gz" | awk '{print $1}')" != "b9a53d539af95412ecce2bdd548eac9beaf559ea48ace5dd8427504c25b01b46" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/perl-$ver.tar.gz" "https://github.com/Perl/perl5/archive/refs/tags/v$ver.tar.gz" || exit 1
fi
crossver='1.6.5'
if [ ! -f "$_DLCACHE/perl-cross-$crossver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/perl-cross-$crossver.tar.gz" | awk '{print $1}')" != "24cccde966c79cec3064c661df519a8d9f710b0b1bb3e2f44c30c1c29e7afbc5" ]; then
    curl -L -# -o "$_DLCACHE/perl-cross-$crossver.tar.gz" "https://github.com/arsv/perl-cross/archive/refs/tags/$crossver.tar.gz" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/perl-$ver.tar.gz"
mv "$_TMP"/perl* "$_SRCDIR"
tar -C "$_SRCDIR" -xf "$_DLCACHE/perl-cross-$crossver.tar.gz"
cp -a "$_SRCDIR/perl-cross-$crossver"/* "$_SRCDIR"
rm -rf "$_SRCDIR/perl-cross-$crossver"
