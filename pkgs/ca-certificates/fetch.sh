#!/bin/sh
. ../../files/dllib.sh
rm -rf "$_DESTDIR" "$_SRCDIR"
mkdir -p "$_SRCDIR"
ver='2026-10-20'
dlfile \
    "https://curl.se/ca/cacert-$ver.pem" \
    "cacert-$ver.pem" \
    796f1389bfea13c0ed78f663b765baaff54a508e5483786bd6ece73c5e3e3cbe
cp "$_DLCACHE/cacert-$ver.pem" "$_SRCDIR/cert.pem"
