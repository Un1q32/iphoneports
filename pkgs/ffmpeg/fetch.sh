#!/bin/sh
. ../../files/dllib.sh
ver='9.0.2'
dlsrc \
    "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" \
    "ffmpeg-$ver.tar.gz" \
    8c3850283eb25fa026482078a04051e0be17347b09ef81a0849bec15a96e002e \
    "ffmpeg-$ver"
