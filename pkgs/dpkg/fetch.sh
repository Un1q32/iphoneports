#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git -c advice.detachedHead=false clone https://git.dpkg.org/git/dpkg/dpkg.git src -b 1.22.14 --depth 1
