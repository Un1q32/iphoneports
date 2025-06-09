#!/bin/sh
set -e
. ../../lib.sh

mkdir -p pkg/var/usr/lib

mkdir src
"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -O3 -flto -c files/libsyscompat.c -o src/libsyscompat.o
"$_TARGET-ar" rcs pkg/var/usr/lib/libsyscompat.a src/libsyscompat.o
