# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A Package for Analyzing Lattice Polytopes"
HOMEPAGE="https://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html"
#SRC_URI="https://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/${P}.tar.gz"
SRC_URI="mirror://sagemath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-gnumakefile.patch
	"${FILESDIR}"/${PN}-2.1-fno-common.patch
	)

# this flag break the executable with certain versions of gcc
filter-flags -ftree-vectorize

pkg_setup() {
	tc-export CC
	Dmax="4 5 6 11"
}

src_prepare(){
	default

	local x
	for x in ${Dmax}; do
		mkdir ${WORKDIR}/build_"${x}"
		cp "${S}"/* "${WORKDIR}/build_${x}"/
		cd "${WORKDIR}/build_${x}"
		sed -i "s:^#define[^a-zA-Z]*POLY_Dmax.*:#define POLY_Dmax ${x}:" Global.h
	done
}

src_compile(){
	local x
	for x in ${Dmax}; do
		einfo "compiling for dimension ${x}"
		cd "${WORKDIR}/build_${x}"
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
