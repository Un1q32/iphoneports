#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/cert.pem https://curl.se/ca/cacert-2025-09-09.pem
