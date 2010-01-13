# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A program for calculating with L-functions"
HOMEPAGE="http://pmmac03.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/"
MY_PN="L"
MY_P="${MY_PN}-${PV}"
SRC_URI="http://pmmac03.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pari"

# TODO: depend on pari[gmp] ?
DEPEND=">=dev-libs/gmp-4.2.1
	pari? ( sci-mathematics/pari )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror test"

S="${WORKDIR}/${MY_P}/src"

# TODO: Support for openmp ?
src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"

	if use pari ; then
		sed -i \
			-e "s:#PARI_DEFINE = -DINCLUDE_PARI:PARI_DEFINE = -DINCLUDE_PARI:g" \
			-e "s:#PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:g" \
			Makefile
	fi
}

src_install() {
	emake DESTDIR="${D}/usr" install || die "emake install failed"

	dodoc ../README
}
