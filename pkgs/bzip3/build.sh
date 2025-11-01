#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-arch-native
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
for script in bin/*; do
    [ "$script" = 'bin/bzip3' ] || [ "$script" = 'bin/bunzip3' ] && continue
    sed -i -e 's|^#!/usr/bin/env sh$|#!/var/usr/bin/sh|' "$script"
done
sed -i -e 's|^#!/bin/sh$|#!/var/usr/bin/sh|' bin/bunzip3
strip_and_sign bin/bzip3 lib/libbzip3.1.dylib
)

installlicense "$_SRCDIR/LICENSE"

builddeb
