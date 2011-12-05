# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils autotools-utils flag-o-matic

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="http://m4ri.sagemath.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug openmp static-libs"

# TODO: tests do not compile since m4rie expects header already being installed
RESTRICT="mirror test"

DEPEND="openmp? ( >=sys-devel/gcc-4.2[openmp] )
	~sci-libs/m4ri-${PV}[openmp?]"
RDEPEND="~sci-libs/m4ri-${PV}[openmp?]"

pkg_setup() {
	# TODO: there should be a better way to fix this
	if use openmp ; then
		append-libs -lgomp
	fi
}

src_prepare() {
	# patch headers to allow out of source build
	epatch "${FILESDIR}"/${P}-trsm.patch
}

src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable openmp)
	)

	autotools-utils_src_configure
}
