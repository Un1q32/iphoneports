#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
git clone https://luajit.org/git/luajit.git source
