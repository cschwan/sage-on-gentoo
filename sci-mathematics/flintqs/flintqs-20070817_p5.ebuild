# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils versionator

MY_P="${PN}-$(replace_version_separator 1 '.')"
SAGE_P="sage-4.6"

DESCRIPTION="William Hart's GPL'd highly optimized multi-polynomial quadratic sieve for integer factorization"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-lanczos.patch
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" CXXFLAGS2="${CXXFLAGS}" \
		LIBS="-lgmp ${LDFLAGS}" || die
}

src_install() {
	dobin QuadraticSieve || die
}
