# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="https://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc metis static-libs tbb"

# spqr requires the supernodal module from cholmod
# enabled by the lapack useflag.
RDEPEND="
	virtual/lapack
	>=sci-libs/cholmod-2[lapack,metis?]
	tbb? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	econf \
		$(use_with doc) \
		$(use_enable static-libs static) \
		$(use_with metis partition) \
		$(use_with tbb)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
