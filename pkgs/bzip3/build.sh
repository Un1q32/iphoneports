#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-arch-native
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
for script in bin/*; do
    [ "$script" = 'bin/bzip3' ] || [ "$script" = 'bin/bunzip3' ] && continue
    sed -i -e 's|^#!/usr/bin/env sh$|#!/var/usr/bin/sh|' "$script"
done
sed -i -e 's|^#!/bin/sh$|#!/var/usr/bin/sh|' bin/bunzip3
"$_TARGET-strip" bin/bzip3 lib/libbzip3.1.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/bzip3 lib/libbzip3.1.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "bzip3-$_DPKGARCH.deb"
