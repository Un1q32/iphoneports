#!/bin/sh
(
cd source || exit 1
ncbuild() {
    ./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --with-default-terminfo-dir=/usr/share/terminfo --with-shared --without-normal --without-debug --enable-termcap --enable-symlinks "$@" CXXFLAGS="-O2 -std=c++11"
    "$_MAKE" -j8
    "$_MAKE" DESTDIR="$_PKGROOT/package" install -j8
}
ncbuild
"$_MAKE" clean
ncbuild --disable-overwrite --enable-widec
)

(
cd package || exit 1
rm -rf usr/man usr/bin/tabs
(
cd usr/share/terminfo || exit 1
for i in ?; do
    x="$(printf %x \'"$i")"
    ln -sn "$i" "$x"
done
)
for i in tic tput tset toe clear infocmp; do
    "$_TARGET-strip" usr/bin/$i > /dev/null 2>&1
    ldid -S"$_BSROOT/entitlements.xml" usr/bin/$i
done
for i in usr/lib/*.dylib; do
    if ! [ -h "$i" ]; then
        "$_TARGET-strip" "$i" -no_code_signature_warning > /dev/null 2>&1
        ldid -S"$_BSROOT/entitlements.xml" "$i"
    fi
done
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ncurses-5.9.deb
