#!/bin/sh
. ../../files/dllib.sh
ver='2.0.3'
dlsrc \
    "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" \
    "wasmi-$ver.tar.gz" \
    584aa0c69691de380f42406e9167b5b0dd18b852678e0c88c1e2c50e21956755 \
    "wasmi-$ver"
