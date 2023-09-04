#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/kyx0r/nextvi.git src
cd src || exit 1
git -c advice.detachedHead=false checkout d3e0924781dd5f48891411b0e6be8697b898e00d
