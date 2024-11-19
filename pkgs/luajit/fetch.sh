#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
cd src || exit 1
git -c advice.detachedHead=false checkout fe71d0fb54ceadfb5b5f3b6baf29e486d97f6059
