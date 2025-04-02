#!/bin/sh
commit=de8f8f732ac1bcf69899df6ffd27dca9a4e66f3c
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/vim/vim/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "vim-${commit}" src
