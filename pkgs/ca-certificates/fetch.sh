#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
curl -L -# -o "$_SRCDIR/cert.pem" https://curl.se/ca/cacert-2026-05-14.pem
