# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib

MY_PN="L"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A program for calculating with L-functions"
HOMEPAGE="http://oto.math.uwaterloo.ca/~mrubinst/L_function_public/L.html"
SRC_URI="http://oto.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="pari"

# TODO: depend on pari[gmp] ?
DEPEND="pari? ( >=sci-mathematics/pari-2.5.0 )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror test"

S="${WORKDIR}/${MY_P}/src"

# TODO: Support for openmp ?
# TODO: Get pari to generate a configuration file to use here
src_prepare() {
	# patch for proper installation routine, flag respect and crufty linking flag removal.
	epatch "${FILESDIR}"/${P}-makefile.patch

	# patches with relative paths will fail in the future
	cd .. || die "failed to change directory"
	epatch "${FILESDIR}"/${PN}-1.23-gcc-4.6-fix.patch
	epatch "${FILESDIR}"/${PN}-1.23-pari-2.5.patch
	cd src || die "failed to change directory"

	# macos patch
	sed -i "s:-dynamiclib:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libLfunction.dylib:g" \
		Makefile || die "failed to fix macos dylib"

	# patch for pari-2.4+ this pari-2.3 safe.
	sed -i "s:lgeti:(long)cgeti:g" Lcommandline_elliptic.cc \
		|| die "sed for lgeti failed"

	# patch pari's location in a prefix safe way.
	sed -i \
		-e "s:LOCATION_PARI_H = /usr/include/pari:LOCATION_PARI_H = ${EPREFIX}/usr/include/pari:" \
		-e "s:LOCATION_PARI_LIBRARY = /usr/lib:LOCATION_PARI_LIBRARY = ${EPREFIX}/usr/$(get_libdir):" \
		Makefile || die "sed for pari location failed"

	if ( use pari ) ; then
		export PARI_DEFINE=-DINCLUDE_PARI
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i "s:.so:.dylib:g" Makefile || die "sed for macos failed"
	fi
}

src_compile() {
	emake CC=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${ED}"/usr LIB_DIR=$(get_libdir) install

	dodoc ../README
}
