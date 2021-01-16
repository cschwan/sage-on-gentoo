# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="https://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran static-libs"

RDEPEND=">=sci-libs/suitesparseconfig-5.4.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.6-dash_doc.patch
	)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable fortran) \
		$(use_with doc) \
		$(use_enable static-libs static)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}

