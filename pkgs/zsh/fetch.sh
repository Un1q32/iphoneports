#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv zsh-* src
curl -L -s -o src/config.guess https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.guess &
curl -L -s -o src/config.sub https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.sub
wait
