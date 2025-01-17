#!/bin/sh
commit=c2a967a1b9adca6c929e3dc5c218dfada00059b6
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/vim/vim/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "vim-${commit}" src
