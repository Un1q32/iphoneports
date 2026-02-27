#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-python --with-zlib --with-lzma PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/doc share/gtk-doc share/man
ln -s libxml2/libxml include/libxml
strip_and_sign bin/xmlcatalog bin/xmllint lib/libxml2.*.dylib
)

installlicense "$_SRCDIR/Copyright"

builddeb
