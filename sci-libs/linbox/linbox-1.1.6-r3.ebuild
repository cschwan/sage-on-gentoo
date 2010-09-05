# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils eutils

DESCRIPTION="LinBox is a C++ template library for linear algebra computation over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ntl sage static-libs"

# TODO: support examples ?

# disabling of commentator class breaks the tests
RESTRICT="mirror
	sage? ( test )"

# FIXME: using external expat breaks the tests.
DEPEND="dev-libs/gmp[-nocxx]
	=sci-libs/givaro-3.2*
	virtual/cblas
	virtual/lapack
	ntl? ( dev-libs/ntl )"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( ChangeLog README NEWS TODO )
PATCHES=(
	"${FILESDIR}"/${P}-fix-config.patch
	"${FILESDIR}"/${P}-nolapack.patch
	"${FILESDIR}"/${P}-fix-double-installation.patch
)

# TODO: installation of documentation does not work ?
src_prepare() {
	autotools-utils_src_prepare

	if use sage ; then
		# disable commentator; this is needed for sage
		epatch "${FILESDIR}"/${P}-disable-commentator.patch

		# fix problem with --as-needed
		epatch "${FILESDIR}"/${P}-fix-undefined-symbols.patch
	fi

	AT_M4DIR=macros eautoreconf
}

src_configure() {
	# TODO: add other configure options ?
	# TODO: support maple, lidia, saclib ?
	# FIXME: using external expat breaks the tests and various other components.

	myeconfargs=(
		--enable-optimization
		$(use_with ntl)
		$(use_enable sage)
	)

	autotools-utils_src_configure
}

pkg_postinst() {
	einfo "One template shipped with linbox needs to be compiled against"
	einfo "lapack. If you use linbox/algorithms/rational-solver.inl you may"
	einfo "have to add -llapack to your flags."
}
