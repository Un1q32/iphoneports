#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
curl -L -# -o src.tar.xz https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz
printf "Unpacking source...\n"
tar -C "$_TMP" -xf src.tar.xz
rm src.tar.xz
mv "$_TMP"/zsh-* "$_SRCDIR"
curl -L -s -o "$_SRCDIR/config.guess" https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.guess &
curl -L -s -o "$_SRCDIR/config.sub" https://raw.githubusercontent.com/tianon/mirror-gnu-config/a2287c3041a3f2a204eb942e09c015eab00dc7dd/config.sub
wait
