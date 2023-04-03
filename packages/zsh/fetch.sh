#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://gigenet.dl.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv zsh-5.9 source
