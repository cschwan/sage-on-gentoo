# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

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

PATCHES=( "${FILESDIR}"/${PN}-2.0-gnumakefile.patch
	"${FILESDIR}"/${PN}-2.0-nonestedfunctions.patch
	"${FILESDIR}"/${PN}-2.0-POLY_Dmax.patch )

pkg_setup() {
	tc-export CC
	Dmax="4 5 6 11"
}

src_prepare(){
	base_src_prepare

	local x
	for x in ${Dmax}; do
		mkdir ${WORKDIR}/build_"${x}"
		cp "${S}"/* "${WORKDIR}/build_${x}"/
	done
}

src_compile(){
	local x
	for x in ${Dmax}; do
		einfo "compiling for dimension ${x}"
		cd "${WORKDIR}/build_${x}"
		export CPPFLAGS="-DPOLY_Dmax=${x}"
		emake
	done
}

src_install() {
	local x
	for x in ${Dmax}; do
		einfo "installing for dimension ${x}"
		cd "${WORKDIR}/build_${x}"
		newbin class.x class-${x}d.x
		newbin cws.x cws-${x}d.x
		newbin nef.x nef-${x}d.x
		newbin poly.x poly-${x}d.x
	done

	dosym class-6d.x /usr/bin/class.x
	dosym cws-6d.x /usr/bin/cws.x
	dosym nef-6d.x /usr/bin/nef.x
	dosym poly-6d.x /usr/bin/poly.x
}
