# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Unsymmetric multifrontal sparse LU factorization library"
HOMEPAGE="https://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +cholmod static-libs"

RDEPEND="
	>=sci-libs/amd-2
	>=sci-libs/suitesparseconfig-5.4.0
	virtual/blas
	cholmod? ( >=sci-libs/cholmod-2[-minimal] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	econf \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		$(use_with doc) \
		$(use_enable static-libs static) \
		$(use_with cholmod)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
