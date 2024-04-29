#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -# -o src.tar.gz https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv ncurses-6.5 src
