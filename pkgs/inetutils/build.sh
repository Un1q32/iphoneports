#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
mkdir "$_PKGROOT/package/bin" "$_PKGROOT/package/sbin"
ln -s ../usr/bin/ping "$_PKGROOT/package/bin/ping"
ln -s ../usr/bin/ping "$_PKGROOT/package/sbin/ping"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/dnsdomainname
"$_TARGET-strip" -x usr/bin/ftp
"$_TARGET-strip" -x usr/bin/hostname
"$_TARGET-strip" -x usr/bin/ifconfig
"$_TARGET-strip" -x usr/bin/logger
"$_TARGET-strip" -x usr/bin/ping
"$_TARGET-strip" -x usr/bin/rcp
"$_TARGET-strip" -x usr/bin/rexec
"$_TARGET-strip" -x usr/bin/rlogin
"$_TARGET-strip" -x usr/bin/rsh
"$_TARGET-strip" -x usr/bin/telnet
"$_TARGET-strip" -x usr/bin/tftp
"$_TARGET-strip" -x usr/bin/traceroute
"$_TARGET-strip" -x usr/bin/whois
"$_TARGET-strip" -x usr/libexec/ftpd
"$_TARGET-strip" -x usr/libexec/inetd
"$_TARGET-strip" -x usr/libexec/rexecd
"$_TARGET-strip" -x usr/libexec/rlogind
"$_TARGET-strip" -x usr/libexec/rshd
"$_TARGET-strip" -x usr/libexec/syslogd
"$_TARGET-strip" -x usr/libexec/telnetd
"$_TARGET-strip" -x usr/libexec/tftpd
"$_TARGET-strip" -x usr/libexec/uucpd
ldid -S"$_BSROOT/entitlements.xml" usr/bin/dnsdomainname
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ftp
ldid -S"$_BSROOT/entitlements.xml" usr/bin/hostname
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ifconfig
ldid -S"$_BSROOT/entitlements.xml" usr/bin/logger
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ping
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rcp
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rexec
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rlogin
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rsh
ldid -S"$_BSROOT/entitlements.xml" usr/bin/telnet
ldid -S"$_BSROOT/entitlements.xml" usr/bin/tftp
ldid -S"$_BSROOT/entitlements.xml" usr/bin/traceroute
ldid -S"$_BSROOT/entitlements.xml" usr/bin/whois
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/ftpd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/inetd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/rexecd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/rlogind
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/rshd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/syslogd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/telnetd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/tftpd
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/uucpd
chmod 4755 usr/bin/ping
chmod 4755 usr/bin/traceroute
chmod 4755 usr/bin/rsh
chmod 4755 usr/bin/rcp
chmod 4755 usr/bin/traceroute
chmod 4755 usr/bin/rlogin
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package inetutils-2.4.deb
