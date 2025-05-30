#!/bin/sh
set -e
. ../../lib.sh

mkdir -p "$_PKGROOT/src/iphoneports-fakebin"
printf '#!/bin/sh\necho %s\n' "$_MACVER" > "$_PKGROOT/src/iphoneports-fakebin/sw_vers"
chmod +x "$_PKGROOT/src/iphoneports-fakebin/sw_vers"
export PATH="$_PKGROOT/src/iphoneports-fakebin:$PATH"

(
cd src
autoreconf -fi

(
mkdir _buildpython && cd _buildpython || exit 1
../configure --prefix="$_PKGROOT/src/buildpython" --without-ensurepip
"$_MAKE" install -j"$_JOBS"
)

./configure --host="$_TARGET" --prefix=/var/usr --build="$(cc -dumpmachine)" --with-build-python="$_PKGROOT/src/buildpython/bin/python3" --without-mimalloc --with-lto --enable-shared --without-ensurepip LDSHARED="$_TARGET-cc -shared -undefined dynamic_lookup" MACHDEP=darwin ac_sys_system=Darwin ac_cv_buggy_getaddrinfo=no ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" CPPFLAGS=-D_DARWIN_USE_64_BIT_INODE
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share lib/python*/test lib/python*/idlelib/idle_test
strip_and_sign "bin/$(readlink bin/python3)" lib/*.dylib lib/python3.13/lib-dynload/*.so
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
