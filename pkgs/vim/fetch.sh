#!/bin/sh
commit=e2c0f81dd014b03a40af6b2c42463b7a0d92f5d6
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/vim/vim/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "vim-${commit}" src
