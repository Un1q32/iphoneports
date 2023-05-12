#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.gz https://ftp.gnu.org/gnu/wget/wget-1.21.4.tar.gz
printf "Unpacking source...\n"
tar -xf source.tar.gz
rm source.tar.gz
mv wget-1.21.4 source
