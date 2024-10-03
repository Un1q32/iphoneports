#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 97813fb924edf822455f91a5fbbdfdb349e5984f
