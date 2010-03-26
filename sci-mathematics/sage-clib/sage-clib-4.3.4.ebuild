# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

MY_P="sage-${PV}"

DESCRIPTION="C library for Sage"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

CDEPEND=">=sci-libs/mpir-1.2.2
	>=dev-libs/ntl-5.4.2
	>=dev-lang/python-2.6.4
	>=sci-libs/pynac-0.1.11
	>=sci-mathematics/pari-2.3.3
	>=sci-mathematics/polybori-0.6.4[sage]"
DEPEND="${CDEPEND}
	>=dev-util/scons-1.2.0"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}/c_lib"

src_prepare(){
	epatch "${FILESDIR}"/${P}-replace-gmp-with-mpir.patch
}

src_compile() {
	# build libcsage.so
	CXX= SAGE_LOCAL=/usr scons || die "scons failed"
}

src_install() {
	dolib.so libcsage.so || die "dolib.so failed"
	insinto /usr/include/csage
	doins include/*.h || die "doins failed"
}
