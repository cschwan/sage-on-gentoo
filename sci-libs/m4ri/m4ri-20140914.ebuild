# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils flag-o-matic

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
#SRC_URI="mirror://sageupstream/lib${PN}/${P}.tar.bz2"
SRC_URI="http://m4ri.sagemath.org/downloads/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug openmp sse2 static-libs"

RESTRICT="mirror"

DEPEND="media-libs/libpng
	virtual/pkgconfig
	openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND="media-libs/libpng"

DOCS=( AUTHORS )

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
