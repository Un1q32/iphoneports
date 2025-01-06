#!/bin/sh
rm -rf pkg src files/syntax
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://ftp.gnu.org/gnu/nano/nano-8.3.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv nano-* src
