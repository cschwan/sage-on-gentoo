# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils toolchain-funcs

DESCRIPTION="FFLAS-FFPACK is a LGPL-2.1+ library for dense linear algebra over word-size finite fields."
HOMEPAGE="http://linalg.org/projects/fflas-ffpack"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND="virtual/cblas
	virtual/lapack
	>=dev-libs/gmp-4.0[cxx]
	>=sci-libs/givaro-3.7.0"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
PATCHES=(
	"${FILESDIR}/${P}-blaslapack-4.patch"
	"${FILESDIR}/${P}-automake-1.13.patch"
	)

pkg_setup(){
	tc-export PKG_CONFIG
}

src_configure() {
	myeconfargs=(
		--enable-optimization
	)

	autotools-utils_src_configure
}
