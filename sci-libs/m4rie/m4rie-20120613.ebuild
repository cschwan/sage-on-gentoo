# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils flag-o-matic

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="mirror://sagemath/lib${P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug openmp static-libs"

# TODO: tests do not compile since m4rie expects header already being installed
RESTRICT="mirror test"

DEPEND="openmp? ( >=sys-devel/gcc-4.2[openmp] )
	~sci-libs/m4ri-${PV}[openmp?]"
RDEPEND="~sci-libs/m4ri-${PV}[openmp?]"

S="${WORKDIR}"/lib${P}/src

pkg_setup() {
	# TODO: there should be a better way to fix this
	if use openmp ; then
		append-libs -lgomp
	fi
}

src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable openmp)
	)

	autotools-utils_src_configure
}
