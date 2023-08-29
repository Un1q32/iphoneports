#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static libplist_LIBS="-lplist-2.0"
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
for bin in bin/inetcat bin/iproxy lib/libusbmuxd-2.0.6.dylib; do
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libusbmuxd.deb