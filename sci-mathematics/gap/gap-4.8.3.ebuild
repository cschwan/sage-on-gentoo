# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools elisp-common

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
GAPDOC="GAPDoc-1.5.1"
SRC_URI="https://github.com/gap-system/gap/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${GAPDOC}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="+gmp emacs readline vim-syntax"

RESTRICT="mirror"

DEPEND="gmp? ( dev-libs/gmp:= )
	readline? ( sys-libs/readline:= )"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? ( app-vim/vim-gap )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.7-writeandcheck.patch
	)

src_prepare(){
	default

	sed -i "s:gapdir=\`pwd\`:gapdir=${EPREFIX}/usr/$(get_libdir)/${PN}:" \
		configure.in || die

	# put GAPdoc in place
	mkdir pkg || die
	mv "${WORKDIR}/${GAPDOC}" pkg/ || die

	eautoreconf
}

src_configure(){
	local myeconfargs
	if (use gmp); then
		myeconfargs="--with-gmp=system"
	else
		myeconfargs="--with-gmp=no"
	fi

	econf \
		$(use_with readline) \
		ABI="" \
		${myeconfargs}

	emake config ABI=""
}

src_install(){
	insinto /usr/$(get_libdir)/${PN}
	# This is excrutiatingly slow even with the reduced content.
	# An install target in the makefile may speed things up.
	doins -r *

	newbin bin/gap.sh gap

	dosym /usr/$(get_libdir)/${PN}/sysinfo.gap /etc/sysinfo.gap

	source sysinfo.gap

	local MUST_BE_EXECUTABLE_FOR_LATER_COMPILING=(
		config.status
		configure
		gap.shi
		makepkgs
		cnf/config.guess
		cnf/config.sub
		cnf/configure.out
		cnf/install-sh
		etc/install-tools.sh
		tst/remake.sh
		)
	for i in ${MUST_BE_EXECUTABLE_FOR_LATER_COMPILING}; do
		fperms 755 /usr/$(get_libdir)/${PN}/$i
	done
	# Make the real gap program executable again after install
	einfo "making /usr/$(get_libdir)/${PN}/bin/${GAParch_system}/gap executable"
	fperms 755 /usr/$(get_libdir)/${PN}/bin/${GAParch_system}/gap
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
