#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
case $_CPU in
    (*64)
        longsize=8
        longdblsize=16
        byteorder=12345678
    ;;
    (arm*)
        longsize=4
        longdblsize=8
        byteorder=1234
    ;;
    (i386)
        longsize=4
        longdblsize=16
        byteorder=1234
    ;;
    (*)
        printf 'Unsupported architecture!\n'
        exit 1
    ;;
esac
# breaks at -O2 for some reason so we use -O1
./configure \
    --target="$_TARGET" \
    --target-tools-prefix="$_TARGET" \
    --prefix=/var/usr \
    --sysroot="$_SDK" \
    -Duseshrplib=true \
    -Dosname=darwin \
    -Dccflags='-DPERL_DARWIN -fno-strict-aliasing -w' \
    -Doptimize='-O2' \
    -Dcharsize=1 \
    -Dshortsize=2 \
    -Dintsize=4 \
    -Dlongsize="$longsize" \
    -Ddoublesize=8 \
    -Dptrsize="$longsize" \
    -Dlongdblsize="$longdblsize" \
    -Dlonglongsize=8 \
    -Dsizesize="$longsize" \
    -Dfpossize=8 \
    -Dlseeksize=8 \
    -Duidsize=4 \
    -Dgidsize=4 \
    -Dtimesize="$longsize" \
    -Dbyteorder="$byteorder" \
    -Dlddlflags='-undefined dynamic_lookup -shared'
make -j"$_JOBS"
make install.perl DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin/perldoc lib/perl5/5.*/pod
for bin in bin/perl $(find lib/perl5 -name "*.so"); do
    if ! [ -w "$bin" ]; then
        chmod u+w "$bin"
        strip_and_sign "$bin"
        chmod u-w "$bin"
    else
        strip_and_sign "$bin"
    fi
done
)

installlicense "$_SRCDIR/Copying"

builddeb
