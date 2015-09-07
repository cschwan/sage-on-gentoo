# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils flag-o-matic

DESCRIPTION="LinBox is a C++ template library for linear algebra computation over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="sage static-libs"

# TODO: support examples ?

# disabling of commentator class breaks the tests
RESTRICT="mirror
	sage? ( test )"

# FIXME: using external expat breaks the tests.
# FIXME: dependency on iml, mpfr, fplll, m4ri and m4rie are automagical
CDEPEND="dev-libs/gmp[cxx]
	>=sci-libs/givaro-3.7.0
	~sci-libs/fflas-ffpack-1.6.0
	virtual/cblas
	virtual/lapack
	sage? ( dev-libs/ntl )
	sci-libs/iml
	dev-libs/mpfr:="
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-clang-fix.patch"
	)

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( ChangeLog README NEWS TODO )

# TODO: installation of documentation does not work ?

pkg_setup() {
	append-libs "-lmpfr" "-liml"
}

src_configure() {
	# FIXME: using external expat breaks the tests and various other components
	# TODO: documentation does not work

	# TODO: what does --enable-optimization do ?
	myeconfargs=(
		--enable-optimization
		--with-default="${EPREFIX}"/usr
		--with-mpfr="${EPREFIX}"/usr
		$(use_enable sage)
	)

	if use sage ; then
		myeconfargs+=(--with-ntl="${EPREFIX}"/usr)
	else
		myeconfargs+=(--with-ntl=no)
	fi

	autotools-utils_src_configure
}
