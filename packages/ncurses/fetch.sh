#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -# -o source.tar.gz https://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv ncurses-5.9 source
