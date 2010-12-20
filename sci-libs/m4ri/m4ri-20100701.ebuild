# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils flag-o-matic

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="http://m4ri.sagemath.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug openmp sse2 static-libs"

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

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	# cachetune option is not available, because it kills (at least my) X when I
	# switch from yakuake to desktop
	myeconfargs=(
		$(use_enable openmp)
		$(use_enable sse2)
	)

	autotools-utils_src_configure
}
