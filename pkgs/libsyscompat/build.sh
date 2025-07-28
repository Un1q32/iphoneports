#!/bin/sh
set -e
. ../../lib.sh

mkdir -p pkg/var/usr/lib

mkdir src
(
cd src
"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -O3 -flto -c ../files/libsyscompat.c -o libsyscompat.o
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 30000 ]; then
    "$_TARGET-ar" x "$_SDK/usr/lib/libgcc_eh.4.2.1.a"
fi
"$_TARGET-ar" rcs ../pkg/var/usr/lib/libsyscompat.a *.o
)
