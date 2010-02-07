# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Gfan computes Groebner fans and tropical varities"
HOMEPAGE="http://www.math.tu-berlin.de/~jensen/software/gfan/gfan.html"
SRC_URI="http://www.math.tu-berlin.de/~jensen/software/gfan/${PN}${PV}plus.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/gmp[-nocxx]
	sci-libs/cddlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}plus/"

RESTRICT="mirror"

src_prepare () {
	sed -i "s/-O2/${CXXFLAGS}/" Makefile

	# TODO: find out what this patch actually fixes
	epatch "${FILESDIR}"/${P}-fix-polynomial.patch
}

# TODO: handle examples and documentation

src_install() {
	emake PREFIX="${D}/usr" install || die "emake install failed"
}
