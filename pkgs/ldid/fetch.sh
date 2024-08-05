#!/bin/sh
commit=798f55bab61c6a3cf45f81014527bbe2b473958b
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/ProcursusTeam/ldid/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "ldid-${commit}" src
