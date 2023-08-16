#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git src
