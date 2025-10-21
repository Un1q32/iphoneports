#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-python --with-zlib --with-lzma PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc share/gtk-doc share/man
ln -s libxml2/libxml include/libxml
strip_and_sign bin/xmlcatalog bin/xmllint lib/libxml2.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/Copyright "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
