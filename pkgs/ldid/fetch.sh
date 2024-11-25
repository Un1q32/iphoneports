#!/bin/sh
commit=ef330422ef001ef2aa5792f4c6970d69f3c1f478
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/ProcursusTeam/ldid/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "ldid-${commit}" src
