#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
cd src || exit 1
git -c advice.detachedHead=false checkout c525bcb9024510cad9e170e12b6209aedb330f83
