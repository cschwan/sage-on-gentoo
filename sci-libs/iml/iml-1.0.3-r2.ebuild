# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpir static-libs"

RESTRICT="mirror"

DEPEND="mpir? ( sci-libs/mpir )
	!mpir? ( >=dev-libs/gmp-3.1.1 )
	virtual/cblas"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )
PATCHES=(
	"${FILESDIR}"/${P}-use-any-cblas-implementation.patch
	"${FILESDIR}"/${P}-fix-undefined-symbol.patch
)

src_prepare() {
	autotools-utils_src_prepare
	AT_M4DIR=config eautoreconf
}
