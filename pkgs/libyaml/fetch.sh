#!/bin/sh
. ../../files/dllib.sh
ver='0.2.6'
dlsrc \
    "https://github.com/yaml/libyaml/releases/download/$ver/yaml-$ver.tar.gz" \
    "libyaml-$ver.tar.gz" \
    43b393a117bd4fe39812fddc94e3d654359a3ae05653dcf0110a1122d1747e61 \
    "yaml-$ver"
