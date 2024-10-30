#!/bin/sh
commit=9f32069b8c4f74aa6af47e2f0ec07f2745feac57
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/vim/vim/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "vim-${commit}" src
