#!/bin/sh
. ../../files/dllib.sh
ver='3.6.4'
dlsrc \
    "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" \
    "openssl-$ver.tar.gz" \
    9bffaa1ad1e07b354c21bd3324ec02fa15579f45a7d0494b3e74bc449b7333ef \
    "openssl-$ver"
