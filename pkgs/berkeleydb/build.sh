#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR/build_unix"
if [ "$_CPU" = "armv6" ]; then
    mutex='--disable-mutexsupport'
fi
../dist/configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-cxx $mutex CPPFLAGS='-w'
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf docs
chmod u+w bin/*
strip_and_sign bin/*
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

installlicense "$_SRCDIR/LICENSE"

builddeb
