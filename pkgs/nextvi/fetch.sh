#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/kyx0r/nextvi.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 3d298f8faf2173f4b0a6da04ec4b8e8f1931c1b6
