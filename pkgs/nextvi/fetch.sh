#!/bin/sh
commit=fdbffae8fe4464a3a0b9acc3bae7b53fa9004a37
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/OldWorldOrdr/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
