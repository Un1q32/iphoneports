#!/bin/sh -e
# shellcheck disable=2086
(
cd src
libqjs_objs='.obj/quickjs.o .obj/libregexp.o .obj/libunicode.o .obj/cutils.o .obj/quickjs-libc.o .obj/libbf.o'
"$_MAKE" CROSS_PREFIX="$_TARGET-" PREFIX=/var/usr CC="$_TARGET-cc -Wno-implicit-const-int-float-conversion" CONFIG_DARWIN=y CONFIG_M32=y CONFIG_LTO= .obj/repl.o .obj/qjs.o .obj/qjscalc.o $libqjs_objs -j"$_JOBS"
"$_TARGET-cc" -funsigned-char -MMD -MF .obj/qjsc.o.d -fwrapv -D_GNU_SOURCE -DCONFIG_VERSION=\"2024-01-13\" -DCONFIG_BIGNUM -DCONFIG_CC=\"gcc\" -DCONFIG_PREFIX=\"/var/usr\" -O3 -flto -c -o .obj/qjsc.o qjsc.c
"$_TARGET-cc" -shared -O3 -flto -o libquickjs.dylib $libqjs_objs -install_name /var/usr/lib/quickjs/libquickjs.dylib -compatibility_version 1 -current_version 1
"$_TARGET-cc" -O3 -flto -o qjs .obj/repl.o .obj/qjs.o .obj/qjscalc.o libquickjs.dylib
"$_TARGET-cc" -O3 -flto -o qjsc .obj/qjsc.o libquickjs.dylib
mkdir -p "$_PKGROOT/pkg/var/usr/bin" "$_PKGROOT/pkg/var/usr/lib/quickjs" "$_PKGROOT/pkg/var/usr/include/quickjs"
cp qjs qjsc "$_PKGROOT/pkg/var/usr/bin"
cp libquickjs.dylib "$_PKGROOT/pkg/var/usr/lib/quickjs"
cp quickjs.h quickjs-libc.h "$_PKGROOT/pkg/var/usr/include/quickjs"
)

(
cd pkg/var/usr
strip_sign bin/qjs bin/qjsc lib/quickjs/libquickjs.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
