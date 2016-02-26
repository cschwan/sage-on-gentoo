# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A C++ template library for linear algebra over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://lig-membres.imag.fr/pernet/prereleases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="sage static-libs openmp"

# TODO: support examples ?

# disabling of commentator class breaks the tests
RESTRICT="mirror
	sage? ( test )"

# FIXME: using external expat breaks the tests.
# FIXME: dependency on iml, mpfr, fplll, m4ri and m4rie are automagical
CDEPEND="dev-libs/gmp[cxx]
	~sci-libs/givaro-4.0.1
	~sci-libs/fflas-ffpack-2.2.0
	virtual/cblas
	virtual/lapack
	sci-libs/fplll
	sage? ( dev-libs/ntl:=
		sci-libs/iml )"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

DOCS=( ChangeLog README NEWS TODO )

# TODO: installation of documentation does not work ?

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

pkg_setup() {
	append-libs "-liml"
}

src_configure() {
	# FIXME: using external expat breaks the tests and various other components
	# TODO: documentation does not work

	if use sage ; then
		myeconfargs+=(--with-ntl="${EPREFIX}"/usr)
	else
		myeconfargs+=(--with-ntl=no)
	fi

	# TODO: what does --enable-optimization do ?
	econf \
		--with-all="${EPREFIX}"/usr \
		$(use_enable sage) \
		$(use_enable openmp) \
		$(use_enable static-libs static) \
		${myeconfargs}
}
