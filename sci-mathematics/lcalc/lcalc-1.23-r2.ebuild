# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils multilib

DESCRIPTION="A program for calculating with L-functions"
HOMEPAGE="http://pmmac03.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/"
MY_PN="L"
MY_P="${MY_PN}-${PV}"
SRC_URI="http://pmmac03.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="pari -pari24 mpfr"

# TODO: depend on pari[gmp] ?
DEPEND="pari24? ( sci-mathematics/pari:3 )
	pari? ( !pari24? ( sci-mathematics/pari:0 ) )
	mpfr? ( dev-libs/mpfr )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror test"

S="${WORKDIR}/${MY_P}/src"

# TODO: Support for openmp ?
# TODO: Get pari to generate a configuration file to use here
src_prepare() {
	# patch for proper installation routine, flag respect and crufty linking flag removal.
	epatch "${FILESDIR}"/${P}-makefile.patch

	# patch for pari-2.4 this pari-2.3 safe.
	sed -i "s:lgeti:(long)cgeti:g" Lcommandline_elliptic.cc || die "sed for lgeti failed"
	# patch pari's location in a prefix safe way.
	sed -i \
		-e "s:LOCATION_PARI_H = /usr/local/include/pari:LOCATION_PARI_H = ${EPREFIX}/usr/include/pari:" \
		-e "s:LOCATION_PARI_LIBRARY = /usr/local/lib:LOCATION_PARI_LIBRARY = ${EPREFIX}/usr/$(get_libdir):" \
		Makefile || die "sed for pari location failed"

	if use pari24 ; then
		sed -i "s:pari:pari24:g" Makefile || die "sed for pari24 failed"
	fi

	if ( use pari || use pari24 ) ; then
		export PARI_DEFINE=-DINCLUDE_PARI
	fi
	if ( use mpfr ) ; then
		export PREPROCESSOR_DEFINE=-DUSE_MPFR
	else
		export PREPROCESSOR_DEFINE=-DUSE_LONG_DOUBLE
	fi
}

src_install() {
	emake DESTDIR="${ED}"/usr LIB_DIR=$(get_libdir) install || die "emake install failed"

	dodoc ../README || die "dodoc failed"
}
