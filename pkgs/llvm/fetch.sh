#!/bin/sh
. ../../files/dllib.sh
ver='23.1.4'
dlsrc \
    "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$ver.tar.gz" \
    "llvm-$ver.tar.gz" \
    3e1c70b30f623976c2046d94b8eeab6cac536f107914cb4ed7bac572a03131db \
    "llvm-project-llvmorg-$ver"

if [ "$_PKGNAME" = 'compiler-rt' ]; then
    ubsanver='4cede088a39199155ba8f7cb1844c46cbd912823'
    _SRCDIR="$_SRCDIR/compiler-rt/ubsan" dlsrc \
        "https://github.com/Un1q32/ubsan/archive/$ubsanver.tar.gz" \
        "ubsan-$ver.tar.gz" \
        b8fe297433d6c62f305fb073a4f4d5c7c776dc7c5edd8ea2a2c98068b5f15b9b \
        "ubsan-$ubsanver"

    printf '%s\n' "${ver%%.*}" > "$_SRCDIR/iphoneports-llvmversion.txt"
fi
