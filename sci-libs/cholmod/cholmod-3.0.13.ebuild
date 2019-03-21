# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="minimal? ( LGPL-2.1 ) !minimal? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="cuda doc +lapack metis minimal static-libs"

RDEPEND="
	>=sci-libs/amd-2.4
	>=sci-libs/colamd-2.9
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )
	lapack? ( virtual/lapack )
	metis? (
		>=sci-libs/camd-2.4
		>=sci-libs/ccolamd-2.9
		|| ( >=sci-libs/metis-5.1.0 sci-libs/parmetis ) )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	local lapack_libs=no
	local blas_libs=no
	if use lapack; then
		blas_libs=$($(tc-getPKG_CONFIG) --libs blas)
		lapack_libs=$($(tc-getPKG_CONFIG) --libs lapack)
	fi

	if use cuda ; then
		export CUBLAS_LIBS="-L${EPREFIX}/opt/cuda/lib64 -lcublas"
		export CUBLAS_CFLAGS="-I${EPREFIX}/opt/cuda/include"
	fi

	econf \
		--with-blas="${blas_libs}" \
		--with-lapack="${lapack_libs}" \
		$(use_with doc) \
		$(use_with !minimal modify) \
		$(use_with !minimal matrixops) \
		$(use_with !minimal partition) \
		$(use_with metis camd) \
		$(use_with metis partition) \
		$(use_with lapack supernodal) \
		$(use_with cuda)
}
