#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cpu="${_TARGET%%-*}"
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_SYSTEM_PROCESSOR="$cpu" -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DBUILD_SHARED_LIBS=yes -DENABLE_NC=yes
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share etc/ssl/cert.pem
ln -s nc bin/netcat
cryptoabi=53
sslabi=56
tlsabi=29
mv lib/libcrypto.$cryptoabi.*.dylib lib/libcrypto.$cryptoabi.dylib
mv lib/libssl.$sslabi.*.dylib lib/libssl.$sslabi.dylib
mv lib/libtls.$tlsabi.*.dylib lib/libtls.$tlsabi.dylib
lib1="$("$_OTOOL" -D lib/libcrypto.$cryptoabi.dylib | tail -1)"
lib2="$("$_OTOOL" -D lib/libssl.$sslabi.dylib | tail -1)"
lib3="$("$_OTOOL" -D lib/libtls.$tlsabi.dylib | tail -1)"
"$_INSTALLNAMETOOL" -id /var/usr/lib/libcrypto.$cryptoabi.dylib lib/libcrypto.$cryptoabi.dylib
"$_INSTALLNAMETOOL" -id /var/usr/lib/libssl.$sslabi.dylib lib/libssl.$sslabi.dylib
"$_INSTALLNAMETOOL" -id /var/usr/lib/libtls.$tlsabi.dylib lib/libtls.$tlsabi.dylib
"$_INSTALLNAMETOOL" -change "$lib1" /var/usr/lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib
"$_INSTALLNAMETOOL" -change "$lib1" /var/usr/lib/libcrypto.$cryptoabi.dylib lib/libtls.$tlsabi.dylib
"$_INSTALLNAMETOOL" -change "$lib2" /var/usr/lib/libssl.$sslabi.dylib lib/libtls.$tlsabi.dylib
"$_INSTALLNAMETOOL" -change "$lib1" /var/usr/lib/libcrypto.$cryptoabi.dylib bin/openssl
"$_INSTALLNAMETOOL" -change "$lib2" /var/usr/lib/libssl.$sslabi.dylib bin/openssl
"$_INSTALLNAMETOOL" -change "$lib1" /var/usr/lib/libcrypto.$cryptoabi.dylib bin/ocspcheck
"$_INSTALLNAMETOOL" -change "$lib2" /var/usr/lib/libssl.$sslabi.dylib bin/ocspcheck
"$_INSTALLNAMETOOL" -change "$lib3" /var/usr/lib/libtls.$tlsabi.dylib bin/ocspcheck
"$_INSTALLNAMETOOL" -change "$lib3" /var/usr/lib/libtls.$tlsabi.dylib bin/nc
llvm-strip bin/openssl bin/ocspcheck bin/nc lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib lib/libtls.$tlsabi.dylib
ldid -S"$_ENT" bin/openssl bin/ocspcheck bin/nc lib/libcrypto.$cryptoabi.dylib lib/libssl.$sslabi.dylib lib/libtls.$tlsabi.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libressl.deb
