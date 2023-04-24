# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic multibuild

DESCRIPTION="A Package for Analyzing Lattice Polytopes"
HOMEPAGE="http://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html"
SRC_URI="http://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/${P}.tar.gz"
#SRC_URI="mirror://sagemath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MULTIBUILD_VARIANTS=( 4 5 6 11 )

# this flag break the executable with certain versions of gcc
filter-flags -ftree-vectorize

pkg_setup() {
	tc-export CC
}

src_prepare(){
	default

	multibuild_copy_sources
}

palp_compile(){
	CPPFLAGS=-DPOLY_Dmax="${MULTIBUILD_VARIANT}" emake
}

src_compile(){
	multibuild_foreach_variant run_in_build_dir palp_compile
}

palp_install(){
	local prog
	for prog in class cws nef poly; do
		newbin "${prog}.x" "${prog}-${MULTIBUILD_VARIANT}d.x"
	done
}

src_install() {
	multibuild_foreach_variant run_in_build_dir palp_install

	dosym class-6d.x /usr/bin/class.x
	dosym cws-6d.x /usr/bin/cws.x
	dosym nef-6d.x /usr/bin/nef.x
	dosym poly-6d.x /usr/bin/poly.x
}
