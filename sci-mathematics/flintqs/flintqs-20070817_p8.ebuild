# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator

MY_P="${PN}-$(replace_version_separator 1 '.')"

DESCRIPTION="William Hart's GPL'd highly optimized multi-polynomial quadratic sieve for integer factorization"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}/src

src_prepare() {
	epatch "${FILESDIR}"/${PN}-lanczos.patch
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" CXXFLAGS2="${CXXFLAGS}" LIBS="-lgmp ${LDFLAGS}"
}

src_install() {
	dobin QuadraticSieve
}
