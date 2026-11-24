#!/bin/sh
. ../../files/dllib.sh
ver='0.2.7'
dlsrc \
    "https://github.com/yaml/libyaml/releases/download/$ver/yaml-$ver.tar.gz" \
    "libyaml-$ver.tar.gz" \
    0c39256b8be0fc689f5c7bfdea1bc9f3fb1fd648468fd3cc6fd375e09ffb6f13 \
    "yaml-$ver"
