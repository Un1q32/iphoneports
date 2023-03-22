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
"$_TARGET-strip" usr/bin/dnsdomainname > /dev/null 2>&1
"$_TARGET-strip" usr/bin/ftp > /dev/null 2>&1
"$_TARGET-strip" usr/bin/hostname > /dev/null 2>&1
"$_TARGET-strip" usr/bin/ifconfig > /dev/null 2>&1
"$_TARGET-strip" usr/bin/logger > /dev/null 2>&1
"$_TARGET-strip" usr/bin/ping > /dev/null 2>&1
"$_TARGET-strip" usr/bin/rcp > /dev/null 2>&1
"$_TARGET-strip" usr/bin/rexec > /dev/null 2>&1
"$_TARGET-strip" usr/bin/rlogin > /dev/null 2>&1
"$_TARGET-strip" usr/bin/rsh > /dev/null 2>&1
"$_TARGET-strip" usr/bin/telnet > /dev/null 2>&1
"$_TARGET-strip" usr/bin/tftp > /dev/null 2>&1
"$_TARGET-strip" usr/bin/traceroute > /dev/null 2>&1
"$_TARGET-strip" usr/bin/whois > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/ftpd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/inetd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/rexecd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/rlogind > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/rshd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/syslogd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/telnetd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/tftpd > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/uucpd > /dev/null 2>&1
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
