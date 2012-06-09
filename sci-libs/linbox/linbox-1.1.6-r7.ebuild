# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils toolchain-funcs eutils flag-o-matic

DESCRIPTION="LinBox is a C++ template library for linear algebra computation over integers and over finite fields"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="ntl sage static-libs"

# TODO: support examples ?

# disabling of commentator class breaks the tests
RESTRICT="mirror
	sage? ( test )"

# FIXME: using external expat breaks the tests.
CDEPEND="dev-libs/gmp[cxx]
	=sci-libs/givaro-3.2*
	virtual/cblas
	ntl? ( dev-libs/ntl )"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

AT_M4DIR="macros"
AUTOTOOLS_IN_SOURCE_BUILD="1"
AUTOTOOLS_AUTORECONF="1"
DOCS=( ChangeLog README NEWS TODO )
PATCHES=(
	"${FILESDIR}"/${P}-gcc.patch
	"${FILESDIR}"/${P}-fix-config.patch
	"${FILESDIR}"/${P}-nolapack.patch
	"${FILESDIR}"/${P}-fix-double-installation.patch
	"${FILESDIR}"/${P}-fix-undefined-symbols.patch
	"${FILESDIR}"/${P}-modularfloat.patch
	"${FILESDIR}"/${P}-disable-commentator.patch
	"${FILESDIR}"/${P}-sage-interface.patch
)

# TODO: installation of documentation does not work ?

pkg_setup(){
	if use sage ; then
		append-cppflags -DDISABLE_COMMENTATOR
	fi
}

src_configure() {
	# FIXME: using external expat breaks the tests and various other components
	# TODO: documentation does not work

	# TODO: what does --enable-optimization do ?
	myeconfargs=(
		--enable-optimization
		--with-blas="$("$(tc-getPKG_CONFIG)" --libs cblas)"
		--with-default="${EPREFIX}"/usr
		--with-ntl="${EPREFIX}"/usr
		$(use_enable sage)
	)

	autotools-utils_src_configure
}

pkg_postinst() {
	einfo "One template shipped with linbox needs to be compiled against"
	einfo "lapack. If you use linbox/algorithms/rational-solver.inl you may"
	einfo "have to add -llapack to your flags."
}
