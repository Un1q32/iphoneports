#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
curl -L -# -o source.tar.xz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.2.tar.xz
printf "Unpacking source...\n"
tar -xf source.tar.xz
rm source.tar.xz
mv git-2.39.2 source
