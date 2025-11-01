#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/sw_vers.c https://raw.githubusercontent.com/darlinghq/darling/refs/heads/master/src/tools/sw_vers.c
