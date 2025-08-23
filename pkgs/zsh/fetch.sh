#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv zsh-5.9 src
curl -L -s -o src/config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=a2287c3041a3f2a204eb942e09c015eab00dc7dd' &
curl -L -s -o src/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=a2287c3041a3f2a204eb942e09c015eab00dc7dd'
wait
