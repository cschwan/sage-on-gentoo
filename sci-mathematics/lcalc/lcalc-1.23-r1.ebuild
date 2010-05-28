# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

MY_P="${PN}-20100428-${PV}"

# TODO: Homepage does no more work

DESCRIPTION="A program for calculating with L-functions"
HOMEPAGE="http://pmmac03.math.uwaterloo.ca/~mrubinst/L_function_public/CODE/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="pari"

# TODO: depend on pari[gmp] ?
DEPEND=">=dev-libs/gmp-4.2.1
	pari? ( sci-mathematics/pari )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror test"

S="${WORKDIR}/${MY_P}/src/src"

# TODO: Support for openmp ?
src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	if use pari ; then
		sed -i \
			-e "s:#PARI_DEFINE = -DINCLUDE_PARI:PARI_DEFINE = -DINCLUDE_PARI:g" \
			-e "s:#PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:g" \
			Makefile || die "sed failed"
	fi
}

src_install() {
	emake DESTDIR="${D}"/usr install || die "emake install failed"

	dodoc ../README || die "dodoc failed"
}
