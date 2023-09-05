#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/kyx0r/nextvi.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 8ca761d8d4d951c97fde28fb68ab10f54f26157f
