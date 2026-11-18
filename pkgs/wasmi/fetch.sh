#!/bin/sh
. ../../files/dllib.sh
ver='2.0.1'
dlsrc \
    "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" \
    "wasmi-$ver.tar.gz" \
    2aeac74bee5eb2f7ba59d2c29c020b5abfee857b2d3e467013686d327296b63d \
    "wasmi-$ver"
