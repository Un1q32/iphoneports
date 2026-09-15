#!/bin/sh
. ../../files/dllib.sh
ver='0.5.13.5'
dlsrc \
    "https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-$ver.tar.gz" \
    "dash-$ver.tar.gz" \
    53622e51df0fd7a2950552cfe0da0bee9bfc1510784e752b62eacc49b3776d33 \
    "dash-$ver"
