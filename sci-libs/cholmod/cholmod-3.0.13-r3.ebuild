# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="https://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="minimal? ( LGPL-2.1 ) !minimal? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
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

	local cudaconfargs=( $(use_with cuda) )
	if use cuda ; then
		cudaconfargs+=(
			--with-cublas-libs="-L${EPREFIX}/opt/cuda/$(get_libdir) -lcublas"
			--with-cublas-cflags="-I${EPREFIX}/opt/cuda/include"
		)
	fi

	econf \
		--with-blas="${blas_libs}" \
		--with-lapack="${lapack_libs}" \
		$(use_with doc) \
		$(use_enable static-libs static) \
		$(use_with !minimal modify) \
		$(use_with !minimal matrixops) \
		$(use_with !minimal partition) \
		$(use_with metis camd) \
		$(use_with metis partition) \
		$(use_with lapack supernodal) \
		"${cudaconfargs[@]}"
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
