#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" -Os \
    -shared \
    -o libduktape.dylib \
    src/duktape.c \
    -install_name /var/usr/lib/libduktape.207.dylib \
    -current_version 207 \
    -compatibility_version 207
"$_TARGET-cc" -Os \
    -o duk \
    examples/cmdline/duk_cmdline.c \
    extras/print-alert/duk_print_alert.c \
    extras/console/duk_console.c \
    extras/logging/duk_logging.c \
    extras/module-duktape/duk_module_duktape.c \
    libduktape.dylib \
    -DDUK_CMDLINE_PRINTALERT_SUPPORT \
    -DDUK_CMDLINE_CONSOLE_SUPPORT \
    -DDUK_CMDLINE_LOGGING_SUPPORT \
    -DDUK_CMDLINE_MODULE_SUPPORT \
    -Iexamples/cmdline \
    -Isrc \
    -Iextras/print-alert \
    -Iextras/console \
    -Iextras/logging \
    -Iextras/module-duktape
mkdir -p "$_DESTDIR/var/usr/bin" "$_DESTDIR/var/usr/lib/pkgconfig" "$_DESTDIR/var/usr/include"
version="$(grep 'DUK_VERSION_FORMATTED =' Makefile.sharedlibrary)"
version="${version#*= }"
sed -e 's|@PREFIX@|/var/usr|' -e 's|@LIBDIR@|/lib|' -e "s|@VERSION@|$version|" duktape.pc.in > "$_DESTDIR/var/usr/lib/pkgconfig/duktape.pc"
cp src/*.h "$_DESTDIR/var/usr/include"
cp libduktape.dylib "$_DESTDIR/var/usr/lib/libduktape.207.dylib"
ln -s libduktape.207.dylib "$_DESTDIR/var/usr/lib/libduktape.dylib"
cp duk "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign bin/duk lib/libduktape.207.dylib
)

installlicense "$_SRCDIR/LICENSE.txt"

builddeb
