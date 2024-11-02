#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/sw_vers.c https://raw.githubusercontent.com/darlinghq/darling/refs/heads/master/src/tools/sw_vers.c
