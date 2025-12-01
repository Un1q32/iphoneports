#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-static-shell --with-readline-header="$_SDK/var/usr/include/readline/readline.h"
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
mv lib/libsqlite3.*.*.*.dylib lib/libsqlite3.0.dylib
ln -sf libsqlite3.0.dylib lib/libsqlite3.dylib
install_name_tool -id /var/usr/lib/libsqlite3.0.dylib lib/libsqlite3.0.dylib 2>/dev/null
install_name_tool -change /var/usr/lib/libsqlite3.dylib /var/usr/lib/libsqlite3.0.dylib bin/sqlite3 2>/dev/null
strip_and_sign bin/sqlite3 lib/libsqlite3.0.dylib
)

installlicense files/LICENSE

builddeb
