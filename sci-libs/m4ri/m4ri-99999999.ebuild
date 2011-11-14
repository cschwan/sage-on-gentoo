# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils flag-o-matic mercurial

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
#SRC_URI="http://m4ri.sagemath.org/downloads/${P}.tar.gz"
EHG_REPO_URI="https://bitbucket.org/malb/m4ri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

	ewarn "This version of m4ri is not compatible with any current release of sage"
	ewarn "It is only provided to ease testing for future release"
	ewarn "see http://trac.sagemath.org/sage_trac/ticket/11574 for 20110715 plans"
}

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
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
