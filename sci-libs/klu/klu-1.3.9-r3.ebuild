# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Sparse LU factorization for circuit simulation"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	>=sci-libs/amd-2.4
	>=sci-libs/btf-1.2
	>=sci-libs/colamd-2.9"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.9-dash_doc.patch
	)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with doc)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
