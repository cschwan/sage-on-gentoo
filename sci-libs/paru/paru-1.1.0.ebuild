# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

Sparse_PV="7.10.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="parallel multifrontal LU factorization algorithms."
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/ParU"
LICENSE="GPL-2+"
SLOT="0/6"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc openmp test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/cholmod-5.3.4[openmp=]
	>=sci-libs/umfpack-6.3.7[openmp=]
	virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# Fortran is only used to compile additional demo programs that can be tested.
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DNSTATIC=ON
		-DSUITESPARSE_USE_OPENMP=$(usex openmp)
		-DSUITESPARSE_USE_FORTRAN=OFF
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Run demo files
	./paru_simplec < "${S}"/Matrix/b1_ss.mtx || die "failed testing b1_ss.mtx"
	./paru_simple  < "${S}"/Matrix/west0067.mtx || die "failed testing west0067.mtx"
	./paru_democ   < "${S}"/Matrix/west0067.mtx || die "failed testing west0067.mtx with paru_democ"
	./paru_demo    < "${S}"/Matrix/xenon1.mtx || die "failed testing xenon1.mtx"
}

src_install() {
	if use doc; then
		pushd "${S}/Doc" || die
		emake clean
		rm -rf *.pdf || die
		emake
		popd || die
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
