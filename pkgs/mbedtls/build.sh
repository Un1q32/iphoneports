#!/bin/sh

mkdir -p pkg/var/usr/lib
mkdir -p pkg/var/usr/include

cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" RL="$_TARGET-ranlib" APPLE_BUILD=1 lib -j8
"$_CP" library/*.a "$_PKGROOT/pkg/var/usr/lib"
"$_CP" -a include/mbedtls "$_PKGROOT/pkg/var/usr/include"
"$_CP" -a include/psa "$_PKGROOT/pkg/var/usr/include"
