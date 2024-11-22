#!/bin/sh

mkdir -p "$_PKGROOT/src/iphoneports-fakebin"
printf '#!/bin/sh\necho 10.6.0\n' > "$_PKGROOT/src/iphoneports-fakebin/sw_vers"
chmod +x "$_PKGROOT/src/iphoneports-fakebin/sw_vers"
export PATH="$_PKGROOT/src/iphoneports-fakebin:$PATH"

(
cd src || exit 1
autoreconf -fi
"$_TARGET-cc" emutls.c atomic.c -O3 -flto -c
./configure --host="$_TARGET" --prefix=/var/usr --build="$(cc -dumpmachine)" --with-build-python=python3 --without-mimalloc --enable-shared --without-ensurepip --with-libs="$_PKGROOT/src/emutls.o $_PKGROOT/src/atomic.o" LDSHARED="$_TARGET-cc -shared -undefined dynamic_lookup" MACHDEP=darwin ac_sys_system=Darwin ac_cv_buggy_getaddrinfo=no ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" "bin/$(readlink bin/python3)" lib/*.dylib lib/python3.13/lib-dynload/*.so 2>/dev/null
ldid -S"$_ENT" "bin/$(readlink bin/python3)" lib/*.dylib lib/python3.13/lib-dynload/*.so
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg python.deb
