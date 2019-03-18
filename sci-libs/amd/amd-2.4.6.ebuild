# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2

DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc fortran static-libs"

RDEPEND=">=sci-libs/suitesparseconfig-5.4.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	econf \
		$(use_enable fortran) \
		$(use_with doc) \
		$(use_enable static-libs static)
}
