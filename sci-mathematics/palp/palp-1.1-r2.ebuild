# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base toolchain-funcs

DESCRIPTION="A Package for Analyzing Lattice Polytopes"
HOMEPAGE="http://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html"
SRC_URI="http://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${PN}-1.1-GNUMakefile.patch )

pkg_setup() {
	tc-export CC
}

src_install() {
	dobin class.x cws.x nef.x poly.x || die
}
