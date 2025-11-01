#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR/xar"
ln -s . include/xar
./configure --host="$_TARGET" --prefix=/var/usr --with-xml2-config="$_SDK/var/usr/bin/xml2-config" --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" LIBS=-lcrypto CPPFLAGS=-Ilib
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/xar lib/libxar.1.dylib
)

installlicense "$_SRCDIR/xar/LICENSE"

builddeb
