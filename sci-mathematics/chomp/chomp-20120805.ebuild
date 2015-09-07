# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit base flag-o-matic toolchain-funcs

MY_PN="${PN}-full"

DESCRIPTION="CHomP computes topological invariants of a collection of n-dimensional cubes"
HOMEPAGE="http://chomp.rutgers.edu/"
SRC_URI="mirror://sagemath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	# since we are replacing compiler flags, add chomp's one
	append-cxxflags -ansi -pedantic -Wall

	# circumvent parallel build failure and use our toolchain
	base_src_compile -j1 CXX=$(tc-getCXX) COMPILE="$(tc-getCXX) ${CXXFLAGS}" \
		LINK="$(tc-getCXX) ${LDFLAGS}" LINKGUI="$(tc-getCXX) ${LDFLAGS}"
}

src_install() {
	dobin bin/*
}
