#!/bin/sh
. ../../files/lib.sh

mkdir -p pkg/var/usr/lib

mkdir src
(
cd src
"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -O3 -flto -c ../files/libsyscompat.c
"$_TARGET-ar" rcs ../pkg/var/usr/lib/libsyscompat.a *.o
)
