#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-arch-native
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
for script in bin/*; do
    [ "$script" = 'bin/bzip3' ] || [ "$script" = 'bin/bunzip3' ] && continue
    sed -i -e 's|^#!/usr/bin/env sh$|#!/var/usr/bin/sh|' "$script"
done
sed -i -e 's|^#!/bin/sh$|#!/var/usr/bin/sh|' bin/bunzip3
strip_and_sign bin/bzip3 lib/libbzip3.1.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
