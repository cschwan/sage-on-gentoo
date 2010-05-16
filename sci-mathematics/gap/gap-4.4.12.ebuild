# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="0"

inherit versionator elisp-common

XTOM_VERSION="1r1p4"

PV1="$(get_version_component_range 1-2 )"
PV2="$(get_version_component_range 3 )"
PV1="$(replace_version_separator 1 'r' ${PV1} )"
PV2="${PV1}p${PV2}"

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/${PN}${PV2}.tar.bz2
	xtom? ( ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/xtom${XTOM_VERSION}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="emacs vim-syntax xtom"

DEPEND=""
RDEPEND="emacs? ( virtual/emacs )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

RESTRICT="mirror"

S="${WORKDIR}/${PN}${PV1}"

src_compile() {
	econf || die "econf failed"
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" compile || die "emake failed"
}

src_test() {
	emake teststandard || die "test failed"
}

src_install() {
	dodoc README description* || die "dodoc failed"

	insinto /usr/share/${PN}
	doins -r doc grp lib pkg prim small trans tst sysinfo.gap || die "doins failed"

	source sysinfo.gap
	exeinto /usr/libexec/${PN}
	doexe bin/${GAParch}/gap || die "doexe failed"

	sed -e "s:@gapdir@:/usr/share/${PN}:" \
		-e "s:@target@-@CC@:/usr/libexec/${PN}:" \
		-e "s:@EXEEXT@::" \
		-e 's:$GAP_DIR/bin/::' \
		gap.shi > gap || die "sed failed"

	exeinto /usr/bin
	doexe gap || die "doexe failed"

	if use emacs ; then
		elisp-site-file-install etc/emacs/gap-mode.el
		elisp-site-file-install etc/emacs/gap-process.el
		elisp-site-file-install "${FILESDIR}"/64gap-gentoo.el
		dodoc etc/emacs/gap-mode.doc || die "dodoc failed"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins etc/gap.vim || die "doins failed"
		insinto /usr/share/vim/vimfiles/indent
		newins etc/gap_indent.vim gap.vim || die "newins failed"
		insinto /usr/share/vim/vimfiles/plugin
		newins etc/debug.vim debug_gap.vim || die "newins failed"
		dodoc etc/README.vim-utils etc/debugvim.txt || die "dodoc failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
