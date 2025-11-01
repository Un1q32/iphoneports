#!/bin/sh
. ../../files/lib.sh
mkdir -p pkg/var/usr/bin
cp src/neofetch pkg/var/usr/bin

installlicense "$_SRCDIR/LICENSE.md"

builddeb
