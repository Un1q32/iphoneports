#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR/build_unix"
case "$_CPU" in
    arm64*) ;;
    arm*) mutex='--with-mutex=Darwin/_spin_lock_try' ;;
esac
../dist/configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-cxx $mutex CPPFLAGS='-w'
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf docs
chmod u+w bin/* include/*
strip_and_sign bin/*
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

installlicense "$_SRCDIR/LICENSE"

builddeb
