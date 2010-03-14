# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=${PV}
SAGE_PACKAGE=sage-${PV}

inherit sage

DESCRIPTION="C library for Sage"
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=sci-libs/mpir-1.2.2
	>=dev-libs/ntl-5.4.2
	>=dev-lang/python-2.6.4
	>=sci-libs/pynac-0.1.11
	>=sci-mathematics/pari-2.3.3
	>=sci-mathematics/polybori-0.6.4[sage]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${SAGE_PACKAGE}/c_lib

src_prepare(){
	epatch "$FILESDIR/${PN}-mpir.patch"
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
