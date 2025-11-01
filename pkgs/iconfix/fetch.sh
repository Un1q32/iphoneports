#!/bin/sh
commit=523b4af65e1a8c0a4a4d2ea6e431588bff7a23b6
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/Un1q32/icon-fix/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "icon-fix-${commit}" "$_SRCDIR"
