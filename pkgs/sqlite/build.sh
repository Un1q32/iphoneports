#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-static-shell --with-readline-header="$_SDK/var/usr/include/readline/readline.h"
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
mv lib/libsqlite3.*.*.*.dylib lib/libsqlite3.0.dylib
ln -sf libsqlite3.0.dylib lib/libsqlite3.dylib
install_name_tool -id /var/usr/lib/libsqlite3.0.dylib lib/libsqlite3.0.dylib
install_name_tool -change /var/usr/lib/libsqlite3.dylib /var/usr/lib/libsqlite3.0.dylib bin/sqlite3
strip_and_sign bin/sqlite3 lib/libsqlite3.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
