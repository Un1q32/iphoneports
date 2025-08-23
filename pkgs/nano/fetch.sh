#!/bin/sh
rm -rf pkg src files/syntax
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://ftpmirror.gnu.org/gnu/nano/nano-8.4.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv nano-* src
