#!/bin/sh
commit=7e0df5eee9eab872261fd5eb0068cec967a2ba77
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/vim/vim/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "vim-${commit}" src
