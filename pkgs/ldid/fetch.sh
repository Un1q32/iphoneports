#!/bin/sh
commit=f38a095aa0cc721c40050cb074116c153608a11b
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/ProcursusTeam/ldid/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "ldid-${commit}" src
