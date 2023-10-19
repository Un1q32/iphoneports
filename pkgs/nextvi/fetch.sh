#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/kyx0r/nextvi.git src
cd src || exit 1
git -c advice.detachedHead=false checkout e975e6d1851c93384f3bea0fdf285a74d69c5f6e
