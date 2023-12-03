#!/bin/sh
commit=b3bc62fcd6455e95fe29b7bd8c62e612fd8b68ee
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/OldWorldOrdr/nextvi/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "nextvi-${commit}" src
