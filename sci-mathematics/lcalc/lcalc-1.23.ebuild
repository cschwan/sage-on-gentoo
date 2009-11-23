# Copyright 1999-2009 Gentoo Foundation
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
IUSE="examples openmp pari"

# TODO: depend on pari[gmp] ?
DEPEND=">=dev-libs/gmp-4.2.1
	sci-mathematics/pari
	openmp? ( sys-devel/gcc[openmp] )"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"

	if use pari ; then
		sed -i \
			-e "s:#PARI_DEFINE = -DINCLUDE_PARI:PARI_DEFINE = -DINCLUDE_PARI:g" \
			-e "s:#PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:PREPROCESSOR_DEFINE = -DUSE_LONG_DOUBLE:g" \
			Makefile
	fi

	# TODO: openmp is not tested
	if use openmp ; then
		sed -i "s:#OPENMP_FLAG = -fopenmp:OPENMP_FLAG = -fopenmp:g" Makefile
	fi
}

# TODO: Fix QA warning
# TODO: examples do not compile

src_compile() {
	emake \
		libLfunction.so  \
		lcalc \
		$(use examples && echo "examples") \
		|| die "emake failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/include
	dodir /usr/lib

	emake DESTDIR="${D}/usr" install || die "emake install failed"

	dodoc ../README
}
