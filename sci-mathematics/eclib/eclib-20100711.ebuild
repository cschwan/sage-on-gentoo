# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils versionator toolchain-funcs multilib prefix

MY_P="${PN}-$(replace_version_separator 1 '.')"
SAGE_P="sage-4.6"

DESCRIPTION="Programs for enumerating and computing with elliptic curves defined over the rational numbers."
HOMEPAGE="http://www.warwick.ac.uk/~masgaj/mwrank/index.html"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="-pari24"

RESTRICT="mirror"

RDEPEND="dev-libs/gmp
	pari24? ( =sci-mathematics/pari-2.4.3-r1 )
	!pari24? ( >=sci-mathematics/pari-2.5.0 )
	>=dev-libs/ntl-5.4.2"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	# patch for shared objects and various make issues.
	epatch "${FILESDIR}"/${P}-makefile.patch.bz2
	epatch "${FILESDIR}"/${P}-makefile.dynamic.patch.bz2
	eprefixify Makefile.dynamic

	sed -i -e "s|@LIB_DIR@|$(get_libdir)|g" Makefile.dynamic
	epatch "${FILESDIR}"/${P}-g0n_makefile.patch.bz2
	epatch "${FILESDIR}"/${P}-procs_makefile.patch.bz2
	epatch "${FILESDIR}"/${P}-qcurves_makefile.patch.bz2
	epatch "${FILESDIR}"/${P}-qrank_makefile.patch.bz2

	if use pari24 ; then
		sed -i "s:-lpari:-lpari24:g" g0n/Makefile \
			|| die "failed to patch g0n/Makefile for pari24"
		sed -i "s:/usr/local/bin/gp:${EPREFIX}/usr/bin/gp-2.4:" \
			procs/gpslave.cc || die "failed to set the right path for pari/gp"
		sed -i "s:pari/pari:pari24/pari:" procs/parifact.cc \
			|| die "failed to patch pari24 headers"
		sed -i "s:-lpari:-lpari24:g" procs/Makefile \
			|| die "failed to patch procs/Makefile for pari24"
		sed -i "s:-lpari:-lpari24:g" qcurves/Makefile \
			|| die "failed to patch qcurves/Makefile for pari24"
		sed -i "s:-lpari:-lpari24:g" qrank/Makefile \
			|| die "failed to patch qrank/Makefile for pari24"
	else
		sed -i "s:/usr/local/bin/gp:${EPREFIX}/usr/bin/gp:" \
			procs/gpslave.cc || die "failed to set the right path for pari/gp"
	fi

	export PARI_PREFIX="${EPREFIX}"/usr
	export NTL_PREFIX="${EPREFIX}"/usr
}

src_compile() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		emake CXX=$(tc-getCXX) dylib
	else
		emake CXX=$(tc-getCXX) so
	fi
}

src_install() {
	dobin bin/*
	dolib.so lib/*$(get_libname)*
	insinto /usr/include/eclib
	doins include/*
}

src_test() {
	emake allcheck
}
