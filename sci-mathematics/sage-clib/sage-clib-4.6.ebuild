# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils scons-utils versionator

MY_P="sage-${PV}"

DESCRIPTION="Sage's C library"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> sage-${PV}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/gmp[-nocxx]
	>=dev-libs/ntl-5.4.2
	>=dev-lang/python-2.6.4
	>=sci-libs/pynac-0.2.0_p5
	sci-mathematics/pari:3
	>=sci-mathematics/polybori-0.6.4[sage]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/c_lib"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.6-importenv.patch
	epatch "${FILESDIR}"/${PN}-4.5.3-fix-undefined-symbols-warning.patch

	# Use pari-2.4
	sed -i "s:pari/:pari24/:" include/convert.h || die "failed to use pari2.4 headers"

	# TODO: write new mpir patch ?
}

src_compile() {
	# build libcsage.so
	CXX= SAGE_LOCAL=/usr UNAME=$(uname) escons || die
}

src_install() {
	dolib.so libcsage.so || die
	insinto /usr/include/csage
	doins include/*.h || die
}
