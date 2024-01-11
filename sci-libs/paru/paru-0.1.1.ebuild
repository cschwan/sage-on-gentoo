# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

Sparse_PV="7.5.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="parallel multifrontal LU factorization algorithms"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +openmp test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.3.1
	>=sci-libs/colamd-3.3.1
	>=sci-libs/camd-3.3.1
	>=sci-libs/ccolamd-3.3.1
	>=sci-libs/cholmod-5.1.1
	>=sci-libs/umfpack-6.3.1
	virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${Sparse_P}/ParU"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}"
	# Run demo files
	./paru_simplec < "${S}"/Matrix/b1_ss.mtx || die "failed testing"
	./paru_simple < "${S}"/Matrix/west0067.mtx || die "failed testing"
	if use openmp; then
		./paru_democ < "${S}"/Matrix/west0067.mtx || die "failed testing"
		./paru_demo < "${S}"/Matrix/xenon1.mtx || die "failed testing"
	fi
}

src_install() {
	if use doc; then
		pushd "${S}/Doc"
		emake clean
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
