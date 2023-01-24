#!/bin/sh
(
cd source || exit 1
ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y ./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
for i in git git-add git-am git-annotate git-apply git-archive git-bisect--helper git-blame git-branch git-bugreport git-bundle git-cat-file git-check-attr git-check-ignore git-check-mailmap git-checkout git-checkout-index git-checkout--worker git-check-ref-format git-cherry git-cherry-pick git-clean git-clone git-column git-commit git-commit-graph git-commit-tree git-config git-count-objects git-credential git-credential-cache git-credential-cache--daemon git-credential-store git-describe git-diagnose git-diff git-diff-files git-diff-index git-difftool git-diff-tree git-env--helper git-fast-export git-fast-import git-fetch git-fetch-pack git-fmt-merge-msg git-for-each-ref git-for-each-repo git-format-patch git-fsck git-fsck-objects git-fsmonitor--daemon git-gc git-get-tar-commit-id git-grep git-hash-object git-help git-hook git-index-pack git-init git-init-db git-interpret-trailers git-log git-ls-files git-ls-remote git-ls-tree git-mailinfo git-mailsplit git-maintenance git-merge git-merge-base git-merge-file git-merge-index git-merge-ours git-merge-recursive git-merge-subtree git-merge-tree git-mktag git-mktree git-multi-pack-index git-mv git-name-rev git-notes git-pack-objects git-pack-redundant git-pack-refs git-patch-id git-prune git-prune-packed git-pull git-push git-range-diff git-read-tree git-rebase git-receive-pack git-reflog git-remote git-remote-ext git-remote-fd git-repack git-replace git-rerere git-reset git-restore git-revert git-rev-list git-rev-parse git-rm git-send-pack git-shortlog git-show git-show-branch git-show-index git-show-ref git-sparse-checkout git-stage git-stash git-status git-stripspace git-submodule--helper git-switch git-symbolic-ref git-tag git-unpack-file git-unpack-objects git-update-index git-update-ref git-update-server-info git-upload-archive git-upload-pack git-var git-verify-commit git-verify-pack git-verify-tag git-version git-whatchanged git-worktree git-write-tree; do
    ln -sf ../../bin/git "usr/libexec/git-core/$i"
done
ln -sf ../../bin/scalar usr/libexec/git-core/scalar
ln -sf ../../bin/git-shell usr/libexec/git-core/git-shell
ln -sf ../../bin/git-cvsserver usr/libexec/git-core/git-cvsserver
ln -sf git-remote-http usr/libexec/git-core/git-remote-ftp
ln -sf git-remote-http usr/libexec/git-core/git-remote-ftps
ln -sf git-remote-http usr/libexec/git-core/git-remote-https
ln -sf git usr/bin/git-receive-pack
ln -sf git usr/bin/git-upload-archive
ln -sf git usr/bin/git-upload-pack
"$_TARGET-strip" usr/bin/git
"$_TARGET-strip" usr/bin/git-shell
"$_TARGET-strip" usr/bin/scalar
"$_TARGET-strip" usr/libexec/git-core/git-remote-http
"$_TARGET-strip" usr/libexec/git-core/git-sh-i18n--envsubst
"$_TARGET-strip" usr/libexec/git-core/git-http-backend
"$_TARGET-strip" usr/libexec/git-core/git-http-fetch
"$_TARGET-strip" usr/libexec/git-core/git-imap-send
"$_TARGET-strip" usr/libexec/git-core/git-daemon
ldid -S"$_PKGROOT/entitlements.xml" usr/bin/git
ldid -S"$_PKGROOT/entitlements.xml" usr/bin/git-shell
ldid -S"$_PKGROOT/entitlements.xml" usr/bin/scalar
ldid -S"$_PKGROOT/entitlements.xml" usr/libexec/git-core/git-remote-http
ldid -S"$_PKGROOT/entitlements.xml" usr/libexec/git-core/git-sh-i18n--envsubst
ldid -S"$_PKGROOT/entitlements.xml" usr/libexec/git-core/git-http-backend
ldid -S"$_PKGROOT/entitlements.xml" usr/libexec/git-core/git-http-fetch
ldid -S"$_PKGROOT/entitlements.xml" usr/libexec/git-core/git-imap-send
ldid -S"$_PKGROOT/entitlements.xml" usr/libexec/git-core/git-daemon
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package git-2.39.1.deb
