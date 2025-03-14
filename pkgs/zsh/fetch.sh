#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv zsh-5.9 src
curl -L -s -o src/config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=00b15927496058d23e6258a28d8996f87cf1f191' &
curl -L -s -o src/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=00b15927496058d23e6258a28d8996f87cf1f191'
wait
