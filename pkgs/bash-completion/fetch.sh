#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://github.com/scop/bash-completion/releases/download/2.12.0/bash-completion-2.12.0.tar.xz
printf "Unpacking source...\n"
tar -xf src.tar.xz
rm src.tar.xz
mv bash-completion-2.12.0 src
