#!/bin/sh
commit=0906344658d5f9b0e0fadadb5ad9cfb3bd63bf89
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/OldWorldOrdr/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
