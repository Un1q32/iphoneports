#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 87ae18af97fd4de790bb6c476b212e047689cc93
