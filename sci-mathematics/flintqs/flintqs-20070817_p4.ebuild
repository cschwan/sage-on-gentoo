# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit versionator

MY_P="${PN}-$(replace_version_separator 1 '.')"

# TODO: Homepage ?

DESCRIPTION="William Hart's GPL'd highly optimized multi-polynomial quadratic
sieve for integer factorization"
# HOMEPAGE=""
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	cp ../patches/lanczos.h . || die "cp failed"

	if use amd64 ; then
		cp makefile.opteron makefile || die "cp failed"
	else
		cp makefile.sage makefile || die "cp failed"
	fi
}

src_install() {
	dobin QuadraticSieve || die "dobin failed"
}
