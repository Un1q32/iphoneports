#!/bin/sh
. ../../files/dllib.sh
ver='2a5705470a92691520fa2ff589482ea6c4039740'
dlsrc \
    "https://github.com/tpoechtrager/apple-libtapi/archive/$ver.tar.gz" \
    "libtapi-$ver.tar.gz" \
    d1ea2f53fb6f0832fd05b0a55b6a05c217e970ba3aa1901d7480885c11239252 \
    "apple-libtapi-$ver"
