# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils flag-o-matic

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="http://sage.math.washington.edu/home/malb/spkgs/libm4ri-20120613.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug openmp sse2 static-libs"
S="${WORKDIR}/libm4ri-20120613/src"

RESTRICT="mirror"

DEPEND="openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND=""

DOCS=( AUTHORS README )

pkg_setup() {
	# TODO: there should be a better way to fix this
	if use openmp ; then
		append-libs -lgomp
	fi
}

src_configure() {
	# cachetune option is not available, because it kills (at least my) X when I
	# switch from yakuake to desktop
	myeconfargs=(
		$(use_enable debug)
		$(use_enable openmp)
		$(use_enable sse2)
	)

	autotools-utils_src_configure
}
