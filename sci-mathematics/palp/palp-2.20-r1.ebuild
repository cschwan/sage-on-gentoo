# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic multibuild

DESCRIPTION="Package for Analyzing Lattice Polytopes (PALP)"
HOMEPAGE="http://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html"
SRC_URI="http://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# The mori.x program writes code to a temporary file and then passes it
# to /usr/bin/Singular to interpret. It also uses cat, grep, awk, and rm
# in shell commands but those are presumed to be available on Gentoo.
RDEPEND="sci-mathematics/singular"

# SageMath has for ever shipped a custom installation of palp that
# builds everything four times: once optimized for dimensions d <= 4,
# once for d <= 5, once for d <= 6, and once for d <= 11 . The resulting
# binaries are given a suffix corresponding to the dimension that they
# were optimized for. For example, the upstream poly.x executable
# optimized for d <= 4 is (and must be for SageMath to utilize it) named
# poly-4d.x.
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
	DIMCPPFLAGS="-DPOLY_Dmax=${MULTIBUILD_VARIANT}"
	CPPFLAGS="${CPPFLAGS} ${DIMCPPFLAGS}" emake
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
