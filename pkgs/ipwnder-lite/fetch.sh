#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/dora2ios/ipwnder_lite --recursive src --depth 1
cd src || exit 1
git -c advice.detachedHead=false checkout cf6d1e6e60727e79c281cd559ebcafd43149e4c1
