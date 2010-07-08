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
IUSE="pari -pari24"

# TODO: depend on pari[gmp] ?
DEPEND=">=dev-libs/gmp-4.2.1
	pari24? ( sci-mathematics/pari:3 )
	pari? ( !pari24? ( sci-mathematics/pari:0 ) )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror test"

S="${WORKDIR}/${MY_P}/src"

# TODO: Support for openmp ?
src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	if ( use pari || use pari24 ) ; then
		sed -i \
			-e "s:#PARI_DEFINE = -DINCLUDE_PARI:PARI_DEFINE = -DINCLUDE_PARI:g" \
			-e "s:#PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:g" \
			Makefile || die "sed failed"
		if use pari24 ; then
			sed -i "s:pari:pari24:g" Makefile || die "sed for pari24 failed"
			sed -i "s:lgeti:(long)cgeti:g" Lcommandline_elliptic.cc || die "sed for lgeti failed"
		fi
	fi
}

src_install() {
	emake DESTDIR="${ED}"/usr LIB_DIR=$(get_libdir) install || die "emake install failed"

	dodoc ../README || die "dodoc failed"
}
