#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
cd src || exit 1
git checkout becf5cc65d966a8926466dd43407c48bfea0fa13
