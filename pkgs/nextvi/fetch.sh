#!/bin/sh
commit=27a03fb546834f10c679911d4efeefce26d8fd2f
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/OldWorldOrdr/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
