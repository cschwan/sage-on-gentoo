# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib autotools-utils versionator elisp-common

PV1="$(get_version_component_range 1-2)"
PV2="$(get_version_component_range 3)"
PV1="$(replace_version_separator 1 'r' ${PV1})"
PV2="${PV1}p${PV2}"
PVSTAMP="_2012_12_14-17_45"

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/${PN}${PV2}${PVSTAMP}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+gmp emacs vim-syntax readline"

RESTRICT="mirror"

DEPEND="gmp? ( dev-libs/gmp )
	readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

PATCHES=(
	"${FILESDIR}/${P}"-cflags.patch
	"${FILESDIR}/${P}"-siginterrupt.patch
	"${FILESDIR}/${P}"-writeandcheck.patch
	"${FILESDIR}/${P}"-testall.patch
	"${FILESDIR}/${P}"-Makefile.patch
	)

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

S="${WORKDIR}/${PN}${PV1}"

src_prepare(){
	# remove useless stuff
	rm -r bin/*
	rm extern/gmp*
	# the xgap pkg is absolutely toxic to sage
	rm -r pkg/xgap

	sed -i "s:gapdir=\`pwd\`:gapdir=${EPREFIX}/usr/$(get_libdir)/${PN}:" \
		configure.in

	autotools-utils_src_prepare
}

src_configure(){
	local myeconfargs=(
		$(use_with readline)
		ABI=""
		)

	if (use gmp); then
		myeconfargs+=(--with-gmp=system)
	else
		myeconfargs+=(--with-gmp=no)
	fi

	autotools-utils_src_configure
	emake config
}

src_compile(){
	# No parallel make possible at this stage.
	emake
}

src_install(){
	insinto /usr/$(get_libdir)/${PN}
	doins -r *

	newbin bin/gap.sh gap

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
		pkg/io/configure
		pkg/orb/configure
		pkg/edim/configure
		pkg/Browse/configure
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
