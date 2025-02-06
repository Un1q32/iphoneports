#!/bin/sh -e
(
cd src || exit 1
"$_TARGET-cc" -Os -shared -o libduktape.dylib src/duktape.c -install_name /var/usr/lib/libduktape.207.dylib -current_version 207 -compatibility_version 207
"$_TARGET-cc" -Os -o duk examples/cmdline/duk_cmdline.c extras/print-alert/duk_print_alert.c extras/console/duk_console.c extras/logging/duk_logging.c extras/module-duktape/duk_module_duktape.c libduktape.dylib -DDUK_CMDLINE_PRINTALERT_SUPPORT -DDUK_CMDLINE_CONSOLE_SUPPORT -DDUK_CMDLINE_LOGGING_SUPPORT -DDUK_CMDLINE_MODULE_SUPPORT -Iexamples/cmdline -Isrc -Iextras/print-alert -Iextras/console -Iextras/logging -Iextras/module-duktape
mkdir -p "$_PKGROOT/pkg/var/usr/bin" "$_PKGROOT/pkg/var/usr/lib/pkgconfig" "$_PKGROOT/pkg/var/usr/include"
version="$(grep 'DUK_VERSION_FORMATTED =' Makefile.sharedlibrary)"
version="${version#*= }"
sed -e 's|@PREFIX@|/var/usr|' -e 's|@LIBDIR@|/lib|' -e "s|@VERSION@|$version|" duktape.pc.in > "$_PKGROOT/pkg/var/usr/lib/pkgconfig/duktape.pc"
cp src/*.h "$_PKGROOT/pkg/var/usr/include"
cp libduktape.dylib "$_PKGROOT/pkg/var/usr/lib/libduktape.207.dylib"
ln -s libduktape.207.dylib "$_PKGROOT/pkg/var/usr/lib/libduktape.dylib"
cp duk "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/duk lib/libduktape.207.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/duk lib/libduktape.207.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "duktape-$_DPKGARCH.deb"
