#!/bin/sh
. ../../files/dllib.sh
rm -rf "$_DESTDIR" "$_SRCDIR"
mkdir -p "$_SRCDIR"
ver='2026-09-25'
dlfile \
    "https://curl.se/ca/cacert-$ver.pem" \
    "cacert-$ver.pem" \
    a41b5d356aea97a529fe27e0f7316d2f9d946d75927476cf9cf1b90637d00505
cp "$_DLCACHE/cacert-$ver.pem" "$_SRCDIR/cert.pem"
