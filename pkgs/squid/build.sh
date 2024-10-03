#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-openssl BUILDCXX=c++ CXXFLAGS='-O2 -Wno-vla-cxx-extension -Wno-gnu-folding-constant' AR="$(command -v "$_TARGET-ar")" enable_arch_native=no
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/libexec || exit 1
rm -rf ../share/icons ../share/man
"$_TARGET-strip" ../bin/squidclient ../bin/purge ../sbin/squid basic_fake_auth basic_getpwnam_auth basic_ncsa_auth basic_radius_auth basic_smb_auth cachemgr.cgi digest_file_auth diskd ext_file_userip_acl ext_unix_group_acl log_file_daemon negotiate_wrapper_auth ntlm_fake_auth unlinkd url_fake_rewrite 2>/dev/null
ldid -S"$_ENT" ../bin/squidclient ../bin/purge ../sbin/squid basic_fake_auth basic_getpwnam_auth basic_ncsa_auth basic_radius_auth basic_smb_auth cachemgr.cgi digest_file_auth diskd ext_file_userip_acl ext_unix_group_acl log_file_daemon negotiate_wrapper_auth ntlm_fake_auth unlinkd url_fake_rewrite
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg squid.deb
