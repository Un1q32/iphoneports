#!/bin/sh
. ../../files/dllib.sh
ver='1.12'
dlsrc \
    "https://github.com/nih-at/libzip/releases/download/v$ver/libzip-$ver.tar.xz" \
    "libzip-$ver.tar.gz" \
    376908d0f0fda13180a19fdc4f7062a1abfb59e09ca07a392d361253b8e60c2b \
    "libzip-$ver"
